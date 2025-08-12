import React, { useState } from 'react';
import GraphComponent from './Graph';
import Directory from './Directory';
import Filter from './Filter';
import './App.css';

function App() {
  const [activeTab, setActiveTab] = useState('graph');
  const [filters, setFilters] = useState({
    roles: [],
    locations: [],
    skills: [],
    contracts: [],
    languages: [],
  });

  const handleFilterChange = (newFilters) => {
    setFilters(newFilters);
  };

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
      <div className="filter-bar">
        <Filter onFilterChange={handleFilterChange} />
      </div>
      <div className="main-container">
        <main className="main-content">
          {activeTab === 'graph' ? <GraphComponent height="100%" filters={filters} /> : <Directory height="100%" filters={filters} />}
        </main>
      </div>
    </div>
  );
}

export default App;
