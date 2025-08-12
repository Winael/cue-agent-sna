import React, { useEffect, useRef, useState } from 'react';
import Sigma from 'sigma';
import Graph from 'graphology';

const nodeTypeColors = {
  Member: '#FF5733',
  service: '#33FF57',
  application: '#33FF57',
  library: '#FF33A1',
  'Daily Scrum': '#A133FF',
  'Scrum of Scrums': '#33FFA1',
  'PI Planning': '#FFC300',
  OKR: '#C70039',
  Team: '#900C3F',
  CommunityOfPractice: '#1ABC9C',
  ValueChain: '#F1C40F',
  Portfolio: '#E67E22',
  SAFeTrain: '#E74C3C'
};

const snaMetricDescriptions = {
  degree_centrality: {
    title: 'Centralité de Degré (Membres)',
    tooltip: 'Affiche les membres les plus connectés.',
    description: 'Identifie les membres avec le plus de connexions directes. Un score élevé signifie une grande implication directe.',
    nodeType: 'Member'
  },
  betweenness_centrality: {
    title: 'Centralité d\'Intermédiarité (Membres)',
    tooltip: 'Identifie les membres qui servent de ponts.',
    description: 'Mesure l\'importance d\'un membre comme intermédiaire. Un score élevé indique un rôle de "courtier" ou de "goulot d\'étranglement".',
    nodeType: 'Member'
  },
  communities: {
    title: 'Communautés (Membres)',
    tooltip: 'Détecte les groupes de membres fortement connectés.',
    description: 'Regroupe les membres qui sont plus densément connectés entre eux qu\'avec le reste du réseau.',
    nodeType: 'Member'
  }
};

const GraphComponent = ({ height }) => {
  const containerRef = useRef(null);
  const sigmaInstanceRef = useRef(null);
  const [originalGraphData, setOriginalGraphData] = useState(null);
  const [snaResults, setSnaResults] = useState(null);
  const [selectedNode, setSelectedNode] = useState(null);
  const [selectedEdge, setSelectedEdge] = useState(null);
  const [interactionMode, setInteractionMode] = useState('default');
  const [rankedNeighbors, setRankedNeighbors] = useState(null);
  const [pathMessage, setPathMessage] = useState(null);

  // Refs to hold latest state for event handlers
  const interactionModeRef = useRef(interactionMode);
  const selectedNodeRef = useRef(selectedNode);

  useEffect(() => {
    interactionModeRef.current = interactionMode;
  }, [interactionMode]);

  useEffect(() => {
    selectedNodeRef.current = selectedNode;
  }, [selectedNode]);

  const loadGraph = (graph, data) => {
    console.log("loadGraph: Clearing graph...");
    graph.clear();
    console.log("loadGraph: Graph cleared. Node count:", graph.order, "Edge count:", graph.size);
    data.nodes.forEach(node => {
      graph.addNode(node.id, {
        ...node,
        color: nodeTypeColors[node.attributes.type] || '#999'
      });
    });
    data.edges.forEach(edge => {
      if (graph.hasNode(edge.source) && graph.hasNode(edge.target)) {
        let edgeColor = '#ccc'; // Default color
        if (edge.label === 'belongs_to') {
          edgeColor = '#FF5733';
        } else if (edge.label && edge.label.startsWith('community_')) {
          edgeColor = '#007bff'; // A distinct color for community relations
        }
        graph.addEdgeWithKey(edge.id, edge.source, edge.target, { ...edge, color: edgeColor });
      }
    });
    console.log("loadGraph: Graph loaded. Node count:", graph.order, "Edge count:", graph.size);
  };

  const resetGraphView = () => {
    if (!sigmaInstanceRef.current || !originalGraphData) return;
    const graph = sigmaInstanceRef.current.getGraph();
    loadGraph(graph, originalGraphData);
    setSnaResults(null);
    setSelectedNode(null);
    setSelectedEdge(null);
    setInteractionMode('default');
    setRankedNeighbors(null);
    setPathMessage(null); // Clear path message on reset
    sigmaInstanceRef.current.refresh();
    sigmaInstanceRef.current.setCameraState({ x: 0, y: 0, ratio: 1 }); // Reset camera on full graph view
    sigmaInstanceRef.current.refresh();
  };

  const fetchEgoNetwork = async (nodeId) => {
    if (!sigmaInstanceRef.current) return;
    try {
      const response = await fetch(`/api/member_subgraph/${nodeId}`);
      const egoData = await response.json();
      const graph = sigmaInstanceRef.current.getGraph();
      graph.clear();
      loadGraph(graph, egoData);
      sigmaInstanceRef.current.refresh();
      sigmaInstanceRef.current.setCameraState({ x: 0, y: 0, ratio: 1 }); // Reset camera for ego network
      sigmaInstanceRef.current.refresh();
    } catch (error) {
      console.error("Error fetching ego network:", error);
    }
  };

  const findShortestPath = async (source, target) => {
    try {
      const response = await fetch(`/api/sna/shortest_path?source=${source}&target=${target}`);
      if (!response.ok) {
        const errorData = await response.json();
        setPathMessage(errorData.detail);
        setInteractionMode('default');
        return;
      }
      setPathMessage(null); // Clear previous message on success
      const path = await response.json();
      console.log("Shortest path received from backend:", path);
      
      const graph = sigmaInstanceRef.current.getGraph();
      
      // Filter nodes to show only the shortest path
      const pathNodes = new Set(path);
      const filteredNodes = originalGraphData.nodes.filter(node => pathNodes.has(node.id));
      
      // Create edges that are part of the shortest path
      const filteredEdges = [];
      for (let i = 0; i < path.length - 1; i++) {
        const sourceNodeId = path[i];
        const targetNodeId = path[i + 1];
        // Find the edge in originalGraphData that connects these two nodes
        const edge = originalGraphData.edges.find(e => 
          (e.source === sourceNodeId && e.target === targetNodeId) ||
          (e.source === targetNodeId && e.target === sourceNodeId) // For undirected graphs
        );
        if (edge) {
          filteredEdges.push(edge);
        }
      }

      console.log("Filtered Nodes for shortest path:", filteredNodes);
      console.log("Filtered Edges for shortest path:", filteredEdges);

      loadGraph(graph, { nodes: filteredNodes, edges: filteredEdges });
      sigmaInstanceRef.current.refresh();
      sigmaInstanceRef.current.setCameraState({ x: 0, y: 0, ratio: 1 }); // Reset camera to fit the new graph
      sigmaInstanceRef.current.refresh(); // Refresh again after camera reset
    } catch (error) {
      console.error("Error finding shortest path:", error);
    }
    setInteractionMode('default');
  };
  
  const analyzeNeighbors = async (nodeId) => {
    try {
      const response = await fetch(`/api/sna/ranked_neighbors?node_id=${nodeId}`);
      const neighbors = await response.json();
      setRankedNeighbors(neighbors);
    } catch (error) {
      console.error("Error analyzing neighbors:", error);
    }
  };

  const fetchAndApplySNA = async (metric, nodeType) => {
    try {
      const url = `/api/sna/${metric}?node_type=${nodeType}`;
      const response = await fetch(url);
      const data = await response.json();
      
      if (!sigmaInstanceRef.current || !originalGraphData) return;
      const graph = sigmaInstanceRef.current.getGraph();
      graph.clear();

      let nodeIdsInAnalysis;
      if (metric === 'communities') {
        nodeIdsInAnalysis = new Set(Object.values(data).flat());
      } else {
        nodeIdsInAnalysis = new Set(Object.keys(data));
      }

      const filteredNodes = originalGraphData.nodes.filter(n => nodeIdsInAnalysis.has(n.id));
      const filteredEdges = originalGraphData.edges.filter(e => nodeIdsInAnalysis.has(e.source) && nodeIdsInAnalysis.has(e.target));
      loadGraph(graph, { nodes: filteredNodes, edges: filteredEdges });

      if (metric === 'communities') {
        const communitySizes = Object.values(data).map(c => c.length);
        setSnaResults({
          ...snaMetricDescriptions[metric],
          keyData: [
            `Nombre de communautés: ${Object.keys(data).length}`,
            `Taille max: ${Math.max(...communitySizes)} membres`,
            `Taille min: ${Math.min(...communitySizes)} membres`,
          ]
        });
        Object.values(data).forEach((community, i) => {
          const color = `#${Math.floor(Math.random()*16777215).toString(16)}`;
          community.forEach(nodeId => {
            if (graph.hasNode(nodeId)) {
              graph.setNodeAttribute(nodeId, 'color', color);
            }
          });
        });
      } else {
        const sortedData = Object.entries(data).sort((a, b) => b[1] - a[1]);
        setSnaResults({
          ...snaMetricDescriptions[metric],
          keyData: sortedData.slice(0, 5).map(([id, score]) => `${id}: ${score.toFixed(4)}`)
        });

        const values = Object.values(data);
        const min = Math.min(...values);
        const max = Math.max(...values);

        Object.entries(data).forEach(([nodeId, value]) => {
          if (graph.hasNode(nodeId)) {
            graph.setNodeAttribute(nodeId, 'size', 5 + ((value - min) / (max - min)) * 25);
          }
        });
      }
      sigmaInstanceRef.current.refresh();

    } catch (error) {
      console.error(`Error loading ${metric}:`, error);
    }
  };

  // Effect for fetching initial graph data
  useEffect(() => {
    let isCancelled = false;
    const fetchData = async (retries = 5) => {
      try {
        const response = await fetch('/api/graph_data');
        if (!response.ok) {
          if (response.status === 503 && retries > 0) {
            setTimeout(() => fetchData(retries - 1), 2000);
            return;
          }
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        if (!isCancelled) {
          setOriginalGraphData(data);
        }
      } catch (error) {
        if (!isCancelled) console.error('Error loading graph data:', error);
      }
    };

    fetchData();

    return () => {
      isCancelled = true;
    };
  }, []); // Only runs once on mount

  // Effect for initializing Sigma.js when container and data are ready
  useEffect(() => {
    const container = containerRef.current;
    if (!container || !originalGraphData) return;

    const graph = new Graph();
    loadGraph(graph, originalGraphData); // Load initial data into graphology graph

    if (sigmaInstanceRef.current) {
      sigmaInstanceRef.current.kill(); // Kill previous instance if it exists
    }

    const sigma = new Sigma(graph, container, {
      renderEdgeLabels: true,
      enableEdgeEvents: true,
      autoRescale: true,
      autoResize: true,
    });
    sigmaInstanceRef.current = sigma;

    // Set up event listeners using refs for latest state
    let draggedNode = null;
    let isDragging = false;

    const handleDownNode = (e) => {
      isDragging = true;
      draggedNode = e.node;
      graph.setNodeAttribute(draggedNode, 'highlighted', true);
    };
    const handleMouseMove = (e) => {
      if (!isDragging || !draggedNode) return;
      const pos = sigma.viewportToGraph(e);
      graph.setNodeAttribute(draggedNode, 'x', pos.x);
      graph.setNodeAttribute(draggedNode, 'y', pos.y);
      e.preventSigmaDefault();
    };
    const handleMouseUp = () => {
      if (draggedNode) {
        graph.removeNodeAttribute(draggedNode, 'highlighted');
      }
      isDragging = false;
      draggedNode = null;
    };
    const handleClickNode = (event) => {
      if (interactionModeRef.current === 'selectPathTarget') {
        findShortestPath(selectedNodeRef.current.id, event.node);
      } else {
        setSelectedEdge(null);
        setRankedNeighbors(null);
        setPathMessage(null);
        setSelectedNode({ id: event.node, attributes: sigma.getGraph().getNodeAttributes(event.node) });
      }
    };

    sigma.on('downNode', handleDownNode);
    sigma.getMouseCaptor().on('mousemove', handleMouseMove);
    sigma.getMouseCaptor().on('mouseup', handleMouseUp);
    sigma.on('clickNode', handleClickNode);

    sigma.on('clickEdge', (event) => {
      setSelectedNode(null);
      setSelectedEdge({ id: event.edge, attributes: graph.getEdgeAttributes(event.edge) });
    });

    sigma.on('clickStage', () => {
      setSelectedNode(null);
      setSelectedEdge(null);
    });

    return () => {
      if (sigmaInstanceRef.current) {
        sigmaInstanceRef.current.kill();
        sigmaInstanceRef.current = null;
      }
    };
  }, [containerRef, originalGraphData]); // Only re-runs if container or originalGraphData changes

  return (
    <div style={{ position: 'relative', width: '100%', height: height }}>
      <div ref={containerRef} style={{ width: '100%', height: '100%' }}></div>
       <div style={{
        position: 'absolute',
        top: '10px',
        left: '10px',
        padding: '10px',
        background: 'rgba(249, 249, 249, 0.85)',
        border: '1px solid #ccc',
        borderRadius: '8px',
        display: 'flex',
        flexDirection: 'column'
      }}>
        <h4>SNA sur les Membres</h4>
        {Object.entries(snaMetricDescriptions).map(([metric, { title, tooltip, nodeType }]) => (
          <button key={metric} onClick={() => fetchAndApplySNA(metric, nodeType)} title={tooltip}>{title}</button>
        ))}
        <button onClick={resetGraphView} style={{marginTop: '10px'}}>Reset</button>
      </div>
      {snaResults && (
        <div style={{
          position: 'absolute',
          top: '10px',
          left: '250px',
          padding: '10px',
          background: 'rgba(249, 249, 249, 0.9)',
          border: '1px solid #ccc',
          borderRadius: '8px',
          maxWidth: '350px',
          boxShadow: '0 2px 10px rgba(0,0,0,0.1)'
        }}>
          <h4>{snaResults.title}</h4>
          <p style={{fontSize: '0.9em'}}>{snaResults.description}</p>
          <h5>Top 5:</h5>
          <ul style={{ listStyleType: 'none', paddingLeft: 0, fontSize: '0.8em' }}>
            {snaResults.keyData.map((item, i) => <li key={i}>{item}</li>)}
          </ul>
          <button onClick={() => setSnaResults(null)} style={{width: '100%'}}>Fermer</button>
        </div>
      )}
      <div style={{
        position: 'absolute',
        bottom: '10px',
        left: '10px',
        padding: '10px',
        background: 'rgba(249, 249, 249, 0.85)',
        border: '1px solid #ccc',
        borderRadius: '8px'
      }}>
        <h2>Légende</h2>
        <ul style={{ listStyleType: 'none', paddingLeft: 0 }}>
          {Object.entries(nodeTypeColors).map(([type, color]) => (
            <li key={type} style={{ marginBottom: '5px' }}>
              <span style={{ display: 'inline-block', width: '12px', height: '12px', backgroundColor: color, marginRight: '8px', verticalAlign: 'middle' }}></span>
              {type}
            </li>
          ))}
        </ul>
      </div>
      {selectedNode && (
        <div style={{
          position: 'absolute',
          top: '10px',
          right: '10px',
          padding: '10px',
          background: 'rgba(249, 249, 249, 0.85)',
          border: '1px solid #ccc',
          borderRadius: '8px',
          maxWidth: '350px',
          maxHeight: '90vh',
          overflowY: 'auto',
          textAlign: 'left',
          boxShadow: '0 2px 10px rgba(0,0,0,0.1)'
        }}>
          <h2>{selectedNode.id}</h2>
          {interactionMode === 'selectPathTarget' && <p style={{color: 'red'}}>Sélectionnez un nœud de destination.</p>}
          <hr />
          <h4>Attributes:</h4>
          <ul style={{ listStyleType: 'none', paddingLeft: 0 }}>
            {Object.entries(selectedNode.attributes.attributes).map(([key, value]) => (
              <li key={key} style={{ marginBottom: '5px' }}>
                <strong>{key}:</strong> {JSON.stringify(value, null, 2)}
              </li>
            ))}
          </ul>
          {selectedNode.attributes.attributes.type === 'Member' && (
            <>
              <hr />
              <h4>Actions</h4>
              <button onClick={() => fetchEgoNetwork(selectedNode.id)} style={{marginTop: '10px'}}>Isoler les relations directes</button>
              <button onClick={() => setInteractionMode('selectPathTarget')} style={{marginTop: '10px'}}>Chemin le plus court vers...</button>
              <button onClick={() => analyzeNeighbors(selectedNode.id)} style={{marginTop: '10px'}}>Analyser les voisins</button>
              {pathMessage && (
                <div style={{marginTop: '10px', color: 'red'}}>
                  <p>{pathMessage}</p>
                </div>
              )}
              {rankedNeighbors && (
                <div style={{marginTop: '10px'}}>
                  <h5>Voisins par Centralité:</h5>
                  <ul style={{ listStyleType: 'none', paddingLeft: 0, fontSize: '0.8em' }}>
                    {Object.entries(rankedNeighbors).map(([id, score]) => <li key={id}>{id}: {score.toFixed(4)}</li>)}
                  </ul>
                </div>
              )}
            </>
          )}
        </div>
      )}
      {selectedEdge && (
        <div style={{
          position: 'absolute',
          top: '10px',
          right: '10px',
          padding: '10px',
          background: 'rgba(249, 249, 249, 0.85)',
          border: '1px solid #ccc',
          borderRadius: '8px',
          maxWidth: '350px',
          maxHeight: '90vh',
          overflowY: 'auto',
          textAlign: 'left',
          boxShadow: '0 2px 10px rgba(0,0,0,0.1)'
        }}>
          <h2>Edge: {selectedEdge.id}</h2>
          <hr />
          <h4>Attributes:</h4>
          <ul style={{ listStyleType: 'none', paddingLeft: 0 }}>
            {Object.entries(selectedEdge.attributes).map(([key, value]) => (
              <li key={key} style={{ marginBottom: '5px' }}>
                <strong>{key}:</strong> {JSON.stringify(value, null, 2)}
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
};

export default GraphComponent;
