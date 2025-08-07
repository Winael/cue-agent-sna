import React, { useEffect, useRef, useState } from 'react';
import Sigma from 'sigma';
import Graph from 'graphology';

const nodeTypeColors = {
  Member: '#FF5733',
  service: '#33FF57',
  application: '#3357FF',
  library: '#FF33A1',
  'Daily Scrum': '#A133FF',
  'Scrum of Scrums': '#33FFA1',
  'PI Planning': '#FFC300',
  OKR: '#C70039',
  Team: '#900C3F',
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

  const loadGraph = (graph, data) => {
    data.nodes.forEach(node => {
      graph.addNode(node.id, {
        ...node,
        color: nodeTypeColors[node.attributes.type] || '#999'
      });
    });
    data.edges.forEach(edge => {
      if (graph.hasNode(edge.source) && graph.hasNode(edge.target)) {
        graph.addEdgeWithKey(edge.id, edge.source, edge.target, { ...edge, color: edge.relation === 'belongs_to' ? '#FF5733' : '#ccc' });
      }
    });
  };

  const resetGraphView = () => {
    if (!sigmaInstanceRef.current || !originalGraphData) return;
    const graph = sigmaInstanceRef.current.getGraph();
    graph.clear();
    loadGraph(graph, originalGraphData);
    setSnaResults(null);
    setSelectedNode(null);
    setSelectedEdge(null);
    sigmaInstanceRef.current.refresh();
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

  useEffect(() => {
    const container = containerRef.current;
    if (!container) return;
    let isCancelled = false;
    let draggedNode = null;
    let isDragging = false;

    const handleDownNode = (e) => {
      isDragging = true;
      draggedNode = e.node;
      const graph = sigmaInstanceRef.current.getGraph();
      graph.setNodeAttribute(draggedNode, 'highlighted', true);
    };
    const handleMouseMove = (e) => {
      if (!isDragging || !draggedNode || !sigmaInstanceRef.current) return;
      const pos = sigmaInstanceRef.current.viewportToGraph(e);
      const graph = sigmaInstanceRef.current.getGraph();
      graph.setNodeAttribute(draggedNode, 'x', pos.x);
      graph.setNodeAttribute(draggedNode, 'y', pos.y);
      e.preventSigmaDefault();
      e.original.preventDefault();
      e.original.stopPropagation();
    };
    const handleMouseUp = () => {
      if (draggedNode) {
        const graph = sigmaInstanceRef.current.getGraph();
        graph.removeNodeAttribute(draggedNode, 'highlighted');
      }
      isDragging = false;
      draggedNode = null;
    };
    const handleClickNode = (event) => {
      setSelectedEdge(null);
      const graph = sigmaInstanceRef.current.getGraph();
      setSelectedNode({ id: event.node, attributes: graph.getNodeAttributes(event.node) });
    };
    const handleClickEdge = (event) => {
      setSelectedNode(null);
      const graph = sigmaInstanceRef.current.getGraph();
      setSelectedEdge({ id: event.edge, attributes: graph.getEdgeAttributes(event.edge) });
    };
    const handleClickStage = () => {
      setSelectedNode(null);
      setSelectedEdge(null);
    };

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
        if (isCancelled) return;

        setOriginalGraphData(data);

        const graph = new Graph();
        loadGraph(graph, data);

        if (sigmaInstanceRef.current) sigmaInstanceRef.current.kill();
        
        const sigma = new Sigma(graph, container, {
          renderEdgeLabels: true,
          enableEdgeEvents: true,
          autoRescale: true,
          autoResize: true,
        });
        sigmaInstanceRef.current = sigma;

        sigma.on('downNode', handleDownNode);
        sigma.getMouseCaptor().on('mousemove', handleMouseMove);
        sigma.getMouseCaptor().on('mouseup', handleMouseUp);
        sigma.on('clickNode', handleClickNode);
        sigma.on('clickEdge', handleClickEdge);
        sigma.on('clickStage', handleClickStage);

      } catch (error) {
        if (!isCancelled) console.error('Error loading graph data:', error);
      }
    };

    fetchData();

    return () => {
      isCancelled = true;
      if (sigmaInstanceRef.current) {
        sigmaInstanceRef.current.kill();
        sigmaInstanceRef.current = null;
      }
    };
  }, []);

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
          left: '250px', // Adjust as needed
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
          <hr />
          <h4>Attributes:</h4>
          <ul style={{ listStyleType: 'none', paddingLeft: 0 }}>
            {Object.entries(selectedNode.attributes).map(([key, value]) => (
              <li key={key} style={{ marginBottom: '5px' }}>
                <strong>{key}:</strong> {JSON.stringify(value, null, 2)}
              </li>
            ))}
          </ul>
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