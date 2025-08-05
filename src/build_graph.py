import networkx as nx
import matplotlib.pyplot as plt
from .load_cue_model import load_model

def build_graph(model):
    """Builds a NetworkX graph from the CUE model data."""
    G = nx.Graph()

    org_data = model.get("myOrg", {})
    teams = org_data.get("teams", [])

    for team in teams:
        team_name = team.get("name")
        G.add_node(team_name, type="Team")

        members = team.get("members", [])
        member_names = [member.get("name") for member in members]

        for member in members:
            member_name = member.get("name")
            G.add_node(member_name, type="Member", role=member.get("role"), team=team_name)
            G.add_edge(team_name, member_name)

        # Add edges between all members of the team
        for i in range(len(member_names)):
            for j in range(i + 1, len(member_names)):
                G.add_edge(member_names[i], member_names[j])

    return G

def draw_graph(G):
    """Draws and saves the graph."""
    plt.figure(figsize=(12, 12))
    pos = nx.spring_layout(G, k=0.5, iterations=50)

    node_colors = []
    for node in G.nodes(data=True):
        if node[1]['type'] == 'Team':
            node_colors.append('skyblue')
        else:
            node_colors.append('lightgreen')

    nx.draw(G, pos, with_labels=True, node_size=2000, node_color=node_colors, font_size=10, font_weight='bold')
    
    # Add role labels to member nodes
    labels = {n: G.nodes[n].get('role', '') for n in G.nodes if G.nodes[n].get('type') == 'Member'}
    nx.draw_networkx_labels(G, pos, labels=labels, font_size=8, verticalalignment='bottom')

    plt.title("Organizational Network Graph")
    plt.savefig("org_graph.png")
    print("Graph saved to org_graph.png")

if __name__ == "__main__":
    model = load_model()
    if model:
        graph = build_graph(model)
        draw_graph(graph)
