import networkx as nx
from .build_graph import build_graph
from .load_cue_model import load_model

def analyze_graph(G):
    """Performs basic SNA on the graph and prints key metrics."""
    print("\n--- Graph Analysis ---")

    # Number of nodes and edges
    print(f"Number of nodes: {G.number_of_nodes()}")
    print(f"Number of edges: {G.number_of_edges()}")

    # Node types distribution
    node_types = nx.get_node_attributes(G, 'type')
    type_counts = {}
    for node, node_type in node_types.items():
        type_counts[node_type] = type_counts.get(node_type, 0) + 1
    print("Node types distribution:")
    for node_type, count in type_counts.items():
        print(f"  {node_type}: {count}")

    # Degree Centrality
    print("\nDegree Centrality (top 5):")
    degree_centrality = nx.degree_centrality(G)
    sorted_degree = sorted(degree_centrality.items(), key=lambda item: item[1], reverse=True)
    for node, centrality in sorted_degree[:5]:
        print(f"  {node}: {centrality:.4f}")

    # Betweenness Centrality
    print("\nBetweenness Centrality (top 5):")
    betweenness_centrality = nx.betweenness_centrality(G)
    sorted_betweenness = sorted(betweenness_centrality.items(), key=lambda item: item[1], reverse=True)
    for node, centrality in sorted_betweenness[:5]:
        print(f"  {node}: {centrality:.4f}")

    # Closeness Centrality
    print("\nCloseness Centrality (top 5):")
    closeness_centrality = nx.closeness_centrality(G)
    sorted_closeness = sorted(closeness_centrality.items(), key=lambda item: item[1], reverse=True)
    for node, centrality in sorted_closeness[:5]:
        print(f"  {node}: {centrality:.4f}")

if __name__ == "__main__":
    model = load_model()
    if model:
        graph = build_graph(model)
        analyze_graph(graph)
