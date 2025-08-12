import React, { useState, useEffect } from 'react';

function Directory({ height, filters }) {
  const [members, setMembers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const buildQueryString = (filters) => {
      const params = new URLSearchParams();
      for (const [key, values] of Object.entries(filters)) {
        if (values.length > 0) {
          values.forEach(value => params.append(key, value));
        }
      }
      return params.toString();
    };

    const fetchData = async (retries = 5) => {
      try {
        const queryString = buildQueryString(filters);
        const response = await fetch(`/api/directory_data?${queryString}`);
        if (!response.ok) {
          if (response.status === 503 && retries > 0) {
            console.warn('Backend not ready, retrying directory data fetch...');
            setTimeout(() => fetchData(retries - 1), 2000); // Retry after 2 seconds
            return;
          }
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        setMembers(data);
        setLoading(false);
      } catch (error) {
        console.error("Error fetching directory data:", error);
        setError(error);
        setLoading(false);
      }
    };

    fetchData();
  }, [filters]);

  if (loading) {
    return <div>Loading directory...</div>;
  }

  if (error) {
    return <div>Error: {error.message}</div>;
  }

  return (
    <div className="directory-container" style={{ height: height }}>
      <h2>Annuaire des Membres</h2>
      <div className="member-list">
        {members.map(member => (
          <div key={member.id} className="member-card">
            <h3>{member.attributes.name}</h3>
            <p><strong>Rôle:</strong> {member.attributes.role}</p>
            <p><strong>Équipe:</strong> {member.attributes.team}</p>
            <p><strong>Compétences:</strong> {member.attributes.skills.join(', ')}</p>
            {member.attributes.manager && <p><strong>Manager:</strong> {member.attributes.manager}</p>}
            <p><strong>Ancienneté:</strong> {member.attributes.seniority}</p>
            <p><strong>Charge de travail:</strong> {member.attributes.workload * 100}%</p>
          </div>
        ))}
      </div>
    </div>
  );
}

export default Directory;
