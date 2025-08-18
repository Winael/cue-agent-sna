import networkx as nx
import community as co
from .build_graph import build_graph
from .load_cue_model import load_model

def get_degree_centrality(G):
    """Calculates degree centrality for all nodes."""
    return nx.degree_centrality(G)

def get_betweenness_centrality(G):
    """Calculates betweenness centrality for all nodes."""
    return nx.betweenness_centrality(G)

def get_closeness_centrality(G):
    """Calculates closeness centrality for all nodes."""
    return nx.closeness_centrality(G)

def get_pagerank(G):
    """Calculates PageRank for all nodes."""
    return nx.pagerank(G)

def get_communities(G):
    """Detects communities using the Louvain method."""
    undirected_G = G.to_undirected()
    partition = co.best_partition(undirected_G)
    communities = {}
    for node, comm_id in partition.items():
        if comm_id not in communities:
            communities[comm_id] = []
        communities[comm_id].append(node)
    return communities

def get_knowledge_sharing_communities(G):
    """
    Detects communities based on knowledge-sharing relationships among members.
    Knowledge-sharing relationships include pairedWith, mentors, askAdviceFrom, talksTo.
    """
    knowledge_graph = nx.Graph() # Undirected graph for community detection

    # Add only Member nodes to the knowledge graph
    for node_id, node_data in G.nodes(data=True):
        if node_data.get("type") == "Member":
            knowledge_graph.add_node(node_id, **node_data)

    # Add knowledge-sharing edges
    for u, v, data in G.edges(data=True):
        relation = data.get("relation")
        if relation in ["pairs_with", "mentors", "asks_advice_from", "talks_to"]:
            # Ensure both nodes are members and exist in our knowledge_graph
            if knowledge_graph.has_node(u) and knowledge_graph.has_node(v):
                knowledge_graph.add_edge(u, v, **data) # Add edge with its attributes

    # Only run community detection if there are edges in the knowledge graph
    if knowledge_graph.number_of_edges() == 0:
        return {} # No communities if no connections

    partition = co.best_partition(knowledge_graph)
    communities = {}
    for node, comm_id in partition.items():
        if comm_id not in communities:
            communities[comm_id] = []
        communities[comm_id].append(node)
    return communities

def get_dependency_bottlenecks(G):
    """Identifies dependency bottlenecks by analyzing in-degree of artifacts."""
    artifact_graph = nx.DiGraph() # Directed graph for dependency analysis

    # Add only Artifact nodes to the dependency graph
    for node_id, node_data in G.nodes(data=True):
        node_type = node_data.get("type")
        if node_type in ["application", "library", "service"]: # Check for actual artifact types
            artifact_graph.add_node(node_id, **node_data)

    # Add dependsOn edges
    for u, v, data in G.edges(data=True):
        relation = data.get("relation")
        if relation == "depends_on": # Assuming 'depends_on' is the relation type for dependencies
            if artifact_graph.has_node(u) and artifact_graph.has_node(v):
                artifact_graph.add_edge(u, v, **data)

    # Calculate in-degree centrality for artifacts
    in_degree_centrality = artifact_graph.in_degree()

    # Filter for artifacts that have incoming dependencies
    bottlenecks = {
        node: degree for node, degree in in_degree_centrality if degree > 0
    }

    # Sort by in-degree in descending order
    sorted_bottlenecks = sorted(bottlenecks.items(), key=lambda item: item[1], reverse=True)

    return dict(sorted_bottlenecks)

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
    degree_centrality = get_degree_centrality(G)
    sorted_degree = sorted(degree_centrality.items(), key=lambda item: item[1], reverse=True)
    for node, centrality in sorted_degree[:5]:
        print(f"  {node}: {centrality:.4f}")

    # Betweenness Centrality
    print("\nBetweenness Centrality (top 5):")
    betweenness_centrality = get_betweenness_centrality(G)
    sorted_betweenness = sorted(betweenness_centrality.items(), key=lambda item: item[1], reverse=True)
    for node, centrality in sorted_betweenness[:5]:
        print(f"  {node}: {centrality:.4f}")

    # Closeness Centrality
    print("\nCloseness Centrality (top 5):")
    closeness_centrality = get_closeness_centrality(G)
    sorted_closeness = sorted(closeness_centrality.items(), key=lambda item: item[1], reverse=True)
    for node, centrality in sorted_closeness[:5]:
        print(f"  {node}: {centrality:.4f}")

    # Average Clustering Coefficient
    undirected_G = G.to_undirected()
    avg_clustering = nx.average_clustering(undirected_G)
    print(f"\nAverage Clustering Coefficient: {avg_clustering:.4f}")

    # Community Detection (Louvain method)
    print("\nCommunity Detection (Louvain Method):")
    communities = get_communities(G)
    for comm_id, nodes in communities.items():
        print(f"  Community {comm_id}: {nodes}")

    # Assortativity by Role
    member_roles = {n: G.nodes[n]['role'] for n in G.nodes if G.nodes[n].get('type') == 'Member' and 'role' in G.nodes[n]}
    if member_roles:
        role_assortativity = nx.attribute_assortativity_coefficient(undirected_G, "role")
        print(f"\nAssortativity by Role: {role_assortativity:.4f}")

    # Assortativity by Seniority
    member_seniorities = {n: G.nodes[n]['seniority'] for n in G.nodes if G.nodes[n].get('type') == 'Member' and 'seniority' in G.nodes[n]}
    if member_seniorities:
        seniority_assortativity = nx.attribute_assortativity_coefficient(undirected_G, "seniority")
        print(f"Assortativity by Seniority: {seniority_assortativity:.4f}")

    # PageRank
    print("\nPageRank (top 5):")
    pagerank = get_pagerank(G)
    sorted_pagerank = sorted(pagerank.items(), key=lambda item: item[1], reverse=True)
    for node, score in sorted_pagerank[:5]:
        print(f"  {node}: {score:.4f}")


if __name__ == "__main__":
    model = load_model()
    if model:
        graph = build_graph(model)
        analyze_graph(graph)