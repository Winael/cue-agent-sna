import React, { useState, useEffect } from 'react';

function Directory({ height }) {
  const [members, setMembers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch('/directory_data.json')
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        setMembers(data);
        setLoading(false);
      })
      .catch(error => {
        console.error("Error fetching directory data:", error);
        setError(error);
        setLoading(false);
      });
  }, []);

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
