import networkx as nx
import matplotlib.pyplot as plt
from .load_cue_model import load_model

def build_graph(model):
    """Builds a NetworkX graph from the CUE model data."""
    G = nx.DiGraph()

    org_data = model.get("myOrg", {})
    teams = org_data.get("teams", [])
    all_members = org_data.get("members", {})
    all_artifacts = org_data.get("artifacts", {})

    # Add all members first to ensure they exist before adding manager edges
    for member_name, member_data in all_members.items():
        G.add_node(member_name, type="Member", **member_data)

    # Add all artifacts first
    for artifact_name, artifact_data in all_artifacts.items():
        G.add_node(artifact_name, **artifact_data)

    for team in teams:
        team_name = team.get("name")
        G.add_node(team_name, type="Team")

        member_names_in_team = team.get("memberNames", [])
        artifact_names_in_team = team.get("artifactNames", [])

        # Add edges between team and its members
        for member_name in member_names_in_team:
            G.add_edge(team_name, member_name, relation="belongs_to")

        # Add edges between team and its artifacts
        for artifact_name in artifact_names_in_team:
            G.add_edge(team_name, artifact_name, relation="owns")

        # Add edges between all members of the team (undirected for collaboration)
        for i in range(len(member_names_in_team)):
            for j in range(i + 1, len(member_names_in_team)):
                # Ensure we don't add duplicate edges if already added by manager relationship
                if not G.has_edge(member_names_in_team[i], member_names_in_team[j]) and \
                   not G.has_edge(member_names_in_team[j], member_names_in_team[i]):
                    G.add_edge(member_names_in_team[i], member_names_in_team[j], relation="collaborates_with")

    # Add manager relationships (directed edges)
    for member_name, member_data in all_members.items():
        manager_name = member_data.get("manager")
        if manager_name and manager_name in all_members:
            G.add_edge(manager_name, member_name, relation="manages")

    # Add artifact dependencies (directed edges)
    for artifact_name, artifact_data in all_artifacts.items():
        for dependency in artifact_data.get("dependsOn", []):
            if dependency in all_artifacts:
                G.add_edge(artifact_name, dependency, relation="depends_on")

    return G

def draw_graph(G):
    """Draws and saves the graph."""
    plt.figure(figsize=(12, 12))
    pos = nx.spring_layout(G, k=0.5, iterations=50)

    node_colors = []
    for node in G.nodes(data=True):
        node_type = node[1]['type']
        if node_type == 'Team':
            node_colors.append('skyblue')
        elif node_type == 'Member':
            node_colors.append('lightgreen')
        elif node_type == 'Artifact':
            node_colors.append('lightcoral')
        else:
            node_colors.append('lightgray')

    nx.draw(G, pos, with_labels=True, node_size=2000, node_color=node_colors, font_size=10, font_weight='bold', arrows=True)
    
    # Add role labels to member nodes
    labels = {n: G.nodes[n].get('role', '') for n in G.nodes if G.nodes[n].get('type') == 'Member'}
    nx.draw_networkx_labels(G, pos, labels=labels, font_size=8, verticalalignment='bottom')

    # Add edge labels for relationships
    edge_labels = nx.get_edge_attributes(G, 'relation')
    nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_size=7, label_pos=0.3)

    plt.title("Organizational Network Graph")
    plt.savefig("org_graph.png")
    print("Graph saved to org_graph.png")

if __name__ == "__main__":
    model = load_model()
    if model:
        graph = build_graph(model)
        draw_graph(graph)
