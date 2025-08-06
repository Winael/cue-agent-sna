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

const GraphComponent = () => {
  const containerRef = useRef(null);
  const sigmaInstanceRef = useRef(null);
  const [selectedNode, setSelectedNode] = useState(null);
  const [selectedEdge, setSelectedEdge] = useState(null);

  useEffect(() => {
    const container = containerRef.current;
    if (!container) return;

    let isCancelled = false;

    fetch('/graph_data.json')
      .then(response => response.json())
      .then(data => {
        if (isCancelled) return;

        const graph = new Graph();

        data.nodes.forEach(node => {
          graph.addNode(node.id, { 
            ...node, 
            color: nodeTypeColors[node.attributes.type] || '#999' 
          });
        });
        data.edges.forEach(edge => {
          graph.addEdgeWithKey(edge.id, edge.source, edge.target, { ...edge, color: edge.relation === 'belongs_to' ? '#FF5733' : '#ccc' });
        });

        if (sigmaInstanceRef.current) {
          sigmaInstanceRef.current.kill();
        }

        const sigma = new Sigma(graph, container, { 
          renderEdgeLabels: true, 
          enableEdgeEvents: true,
          autoRescale: true, 
          autoResize: true 
        });
        sigmaInstanceRef.current = sigma;

        let draggedNode = null;
        let isDragging = false;

        sigma.on('downNode', (e) => {
          isDragging = true;
          draggedNode = e.node;
          graph.setNodeAttribute(draggedNode, 'highlighted', true);
        });

        sigma.getMouseCaptor().on('mousemove', (e) => {
          if (!isDragging || !draggedNode) return;

          const pos = sigma.viewportToGraph(e);

          graph.setNodeAttribute(draggedNode, 'x', pos.x);
          graph.setNodeAttribute(draggedNode, 'y', pos.y);

          e.preventSigmaDefault();
          e.original.preventDefault();
          e.original.stopPropagation();
        });

        sigma.getMouseCaptor().on('mouseup', () => {
          if (draggedNode) {
            graph.removeNodeAttribute(draggedNode, 'highlighted');
          }
          isDragging = false;
          draggedNode = null;
        });

        sigma.on('clickNode', (event) => {
          setSelectedEdge(null);
          setSelectedNode({ id: event.node, attributes: graph.getNodeAttributes(event.node) });
        });

        sigma.on('clickEdge', (event) => {
          setSelectedNode(null);
          setSelectedEdge({ id: event.edge, attributes: graph.getEdgeAttributes(event.edge) });
        });

        sigma.on('clickStage', () => {
          setSelectedNode(null);
          setSelectedEdge(null);
        });
      })
      .catch(error => {
        if (!isCancelled) {
          console.error('Error loading graph data:', error);
        }
      });

    return () => {
      isCancelled = true;
      if (sigmaInstanceRef.current) {
        sigmaInstanceRef.current.kill();
        sigmaInstanceRef.current = null;
      }
    };
  }, []);

  return (
    <div style={{ position: 'relative', width: '100%', height: '100%' }}>
      <div ref={containerRef} style={{ width: '100%', height: '100%' }}></div>
      <div style={{
        position: 'absolute',
        top: '10px',
        left: '10px',
        padding: '10px',
        background: 'rgba(249, 249, 249, 0.85)',
        border: '1px solid #ccc',
        borderRadius: '8px'
      }}>
        <h2>Legend</h2>
        <ul style={{ listStyleType: 'none', paddingLeft: 0 }}>
          {Object.entries(nodeTypeColors).map(([type, color]) => (
            <li key={type} style={{ marginBottom: '5px' }}>
              <span style={{
                display: 'inline-block',
                width: '12px',
                height: '12px',
                backgroundColor: color,
                marginRight: '8px',
                verticalAlign: 'middle'
              }}></span>
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