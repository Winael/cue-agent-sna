import React, { useState } from 'react';
import GraphComponent from './Graph';
import Directory from './Directory';
import './App.css';

function App() {
  const [activeTab, setActiveTab] = useState('graph');

  return (
    <div className="App">
      <header className="App-header">
        <h1>Organizational Network Dashboard</h1>
        <nav>
          <button onClick={() => setActiveTab('graph')}
                  className={activeTab === 'graph' ? 'active' : ''}>
            Graph
          </button>
          <button onClick={() => setActiveTab('directory')}
                  className={activeTab === 'directory' ? 'active' : ''}>
            Annuaire
          </button>
        </nav>
      </header>
      <main>
        {activeTab === 'graph' ? <GraphComponent height="100%" /> : <Directory height="100%" />}
      </main>
    </div>
  );
}

export default App;
