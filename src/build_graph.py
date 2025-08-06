import networkx as nx
import matplotlib.pyplot as plt
import json
from load_cue_model import load_model

def build_graph(model):
    """Builds a NetworkX graph from the CUE model data."""
    G = nx.DiGraph()

    org_data = model.get("myOrg", {})
    teams = org_data.get("teams", [])
    all_members = org_data.get("members", {})
    all_artifacts = org_data.get("artifacts", {})
    all_rituals = org_data.get("rituals", {})
    all_okrs = org_data.get("okrs", {})
    value_chains = org_data.get("valueChains", [])
    portfolios = org_data.get("portfolios", [])
    trains = org_data.get("trains", [])

    # Add value chains
    for vc in value_chains:
        vc_name = vc.get("name")
        G.add_node(vc_name, type="ValueChain", **vc)

    # Add portfolios
    for portfolio in portfolios:
        portfolio_name = portfolio.get("name")
        G.add_node(portfolio_name, type="Portfolio", **portfolio)
        vc_name = portfolio.get("valueChain", {}).get("name")
        if vc_name and G.has_node(vc_name):
            G.add_edge(portfolio_name, vc_name, relation="part_of")

    # Add SAFe trains
    for train in trains:
        train_name = train.get("name")
        G.add_node(train_name, type="SAFeTrain", **train)
        portfolio_name = train.get("portfolio", {}).get("name")
        if portfolio_name and G.has_node(portfolio_name):
            G.add_edge(train_name, portfolio_name, relation="part_of")

    # Add all members first to ensure they exist before adding manager edges
    for member_name, member_data in all_members.items():
        G.add_node(member_name, type="Member", **member_data)

    # Add all artifacts first
    for artifact_name, artifact_data in all_artifacts.items():
        G.add_node(artifact_name, **artifact_data)

    # Add all rituals first
    for ritual_name, ritual_data in all_rituals.items():
        G.add_node(ritual_name, **ritual_data)

    # Add all OKRs first
    for okr_name, okr_data in all_okrs.items():
        G.add_node(okr_name, type="OKR", **okr_data)

    for team in teams:
        team_name = team.get("name")
        G.add_node(team_name, type="Team")

        member_names_in_team = team.get("memberNames", [])
        artifact_names_in_team = team.get("artifactNames", [])
        okr_names_in_team = team.get("okrNames", [])

        # Add edge between team and its train
        train_name = team.get("train", {}).get("name")
        if train_name and G.has_node(train_name):
            G.add_edge(team_name, train_name, relation="belongs_to")

        # Add edges between team and its members
        for member_name in member_names_in_team:
            G.add_edge(team_name, member_name, relation="belongs_to")

        # Add edges between team and its artifacts
        for artifact_name in artifact_names_in_team:
            G.add_edge(team_name, artifact_name, relation="owns")

        # Add edges between team and its OKRs
        for okr_name in okr_names_in_team:
            if okr_name in all_okrs:
                G.add_edge(team_name, okr_name, relation="owns_okr")

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

    # Add ritual participants (directed edges from ritual to member)
    for ritual_name, ritual_data in all_rituals.items():
        for participant_name in ritual_data.get("participants", []):
            if participant_name in all_members:
                G.add_edge(ritual_name, participant_name, relation="participates_in")

    # Add OKR ownership relationships (directed edges from owner to OKR)
    for okr_name, okr_data in all_okrs.items():
        owner_name = okr_data.get("owner")
        # Check if owner is a Team, SAFeTrain, or Portfolio
        if owner_name:
            # Find the actual owner object (Team, SAFeTrain, Portfolio)
            owner_node = None
            for team in teams:
                if team.get("name") == owner_name:
                    owner_node = team.get("name")
                    break
            if not owner_node:
                for train in org_data.get("trains", []):
                    if train.get("name") == owner_name:
                        owner_node = train.get("name")
                        break
            if not owner_node:
                for portfolio in org_data.get("portfolios", []):
                    if portfolio.get("name") == owner_name:
                        owner_node = portfolio.get("name")
                        break
            
            if owner_node and G.has_node(owner_node):
                G.add_edge(owner_node, okr_name, relation="owns_okr")

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
        elif node_type == 'Ritual':
            node_colors.append('lightsalmon')
        elif node_type == 'OKR':
            node_colors.append('gold')
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

def export_graph_to_json(G, filename="dashboard/public/graph_data.json"):
    """Exports the NetworkX graph to a JSON format suitable for Sigma.js."""
    nodes = []
    edges = []

    # Generate positions for nodes (using the same layout as for drawing)
    pos = nx.spring_layout(G, k=0.5, iterations=50)

    for i, node_id in enumerate(G.nodes()):
        node_data = G.nodes[node_id]
        x, y = pos[node_id]
        nodes.append({
            "id": node_id,
            "label": node_id,
            "x": float(x),
            "y": float(y),
            "size": 10, # Default size, can be adjusted
            "color": "#999", # Default color, can be adjusted based on type
            "attributes": node_data # Include all node attributes
        })

    for i, (source, target, edge_data) in enumerate(G.edges(data=True)):
        edges.append({
            "id": f"e{i}",
            "source": source,
            "target": target,
            "label": edge_data.get("relation", ""),
            "type": "arrow", # For directed edges
            "attributes": edge_data # Include all edge attributes
        })

    graph_data = {"nodes": nodes, "edges": edges}

    with open(filename, 'w') as f:
        json.dump(graph_data, f, indent=2)
    print(f"Graph data exported to {filename}")

if __name__ == "__main__":
    model = load_model()
    if model:
        graph = build_graph(model)
        draw_graph(graph)
        export_graph_to_json(graph)
