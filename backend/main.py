from fastapi import FastAPI, HTTPException, Query
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from src.load_cue_model import load_model
from src.build_graph import build_graph
import src.analyze_graph as sna
import networkx as nx
import asyncio
from watchfiles import awatch
from typing import Optional, List

app = FastAPI()

# Global variables to cache the graph and its layout
cached_graph = None
cached_pos = None

async def load_and_cache_graph_data():
    global cached_graph, cached_pos
    print("Loading and caching graph data...")
    model = load_model()
    if model:
        cached_graph = build_graph(model)
        cached_pos = nx.spring_layout(cached_graph, k=0.5, iterations=50)
        print("Graph data loaded and cached.")
    else:
        print("Failed to load CUE model.")

async def watch_cue_files():
    print("Starting CUE file watcher...")
    async for changes in awatch('./cue', recursive=True):
        print(f"Detected changes in CUE files: {changes}. Reloading graph data...")
        await load_and_cache_graph_data()

@app.on_event("startup")
async def startup_event():
    await load_and_cache_graph_data()
    asyncio.create_task(watch_cue_files())

def get_subgraph_by_type(graph, node_type: str):
    """Creates a subgraph containing only nodes of a specific type."""
    if not node_type:
        return graph
    
    nodes_of_type = [
        node for node, data in graph.nodes(data=True) 
        if data.get("type") == node_type
    ]
    return graph.subgraph(nodes_of_type)

@app.get("/api/graph_data")
async def get_graph_data(
    node_types: Optional[List[str]] = Query(None),
    edge_relations: Optional[List[str]] = Query(None)
):
    global cached_graph, cached_pos
    if cached_graph is None or cached_pos is None:
        raise HTTPException(status_code=503, detail="Graph data not loaded yet. Please try again in a moment.")

    try:
        filtered_nodes = []
        filtered_edges = []
        
        # Filter nodes
        nodes_to_include = set()
        for node_id in cached_graph.nodes():
            node_data = cached_graph.nodes[node_id]
            if node_types is None or node_data.get("type") in node_types:
                nodes_to_include.add(node_id)
                x, y = cached_pos[node_id]
                filtered_nodes.append({
                    "id": node_id,
                    "label": node_id,
                    "x": float(x),
                    "y": float(y),
                    "size": 10, # Default size, can be adjusted
                    "color": node_data.get("color", "#999"), # Use color from node_data if available
                    "attributes": node_data # Include all node attributes
                })

        # Filter edges and ensure both source and target nodes are included
        for i, (source, target, edge_data) in enumerate(cached_graph.edges(data=True)):
            relation = edge_data.get("relation")
            if (edge_relations is None or relation in edge_relations) and \
               source in nodes_to_include and target in nodes_to_include:
                filtered_edges.append({
                    "id": f"e{i}",
                    "source": source,
                    "target": target,
                    "label": relation,
                    "type": "arrow", # For directed edges
                    "attributes": edge_data # Include all edge attributes
                })

        graph_data = {"nodes": filtered_nodes, "edges": filtered_edges}
        return JSONResponse(content=graph_data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error loading graph data: {e}")


@app.get("/api/directory_data")
async def get_directory_data(
    roles: Optional[List[str]] = Query(None),
    locations: Optional[List[str]] = Query(None),
    skills: Optional[List[str]] = Query(None),
    contracts: Optional[List[str]] = Query(None),
    languages: Optional[List[str]] = Query(None),
):
    global cached_graph
    if cached_graph is None:
        raise HTTPException(status_code=503, detail="Directory data not loaded yet. Please try again in a moment.")

    try:
        members = []
        for node_id, node_data in cached_graph.nodes(data=True):
            if node_data.get("type") == "Member":
                # Filtering logic
                if roles and node_data.get("role") not in roles:
                    continue
                if locations and node_data.get("location") not in locations:
                    continue
                if contracts and node_data.get("contract") not in contracts:
                    continue
                if skills and not set(node_data.get("skills", [])).intersection(set(skills)):
                    continue
                if languages and not set(node_data.get("language", [])).intersection(set(languages)):
                    continue
                
                members.append({
                    "id": node_id,
                    "attributes": node_data
                })
        return JSONResponse(content=members)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error loading directory data: {e}")

@app.post("/api/reload_graph")
async def reload_graph():
    asyncio.create_task(load_and_cache_graph_data())
    return {"message": "Graph reload initiated in background."}

@app.get("/api/filter_options")
async def get_filter_options():
    if cached_graph is None:
        raise HTTPException(status_code=503, detail="Graph data not loaded yet.")

    try:
        roles = set()
        locations = set()
        skills = set()
        contracts = set()
        languages = set()

        for node_id, node_data in cached_graph.nodes(data=True):
            if node_data.get("type") == "Member":
                if "role" in node_data:
                    roles.add(node_data["role"])
                if "location" in node_data:
                    locations.add(node_data["location"])
                if "skills" in node_data:
                    skills.update(node_data["skills"])
                if "contract" in node_data:
                    contracts.add(node_data["contract"])
                if "language" in node_data:
                    languages.update(node_data["language"])

        return JSONResponse(content={
            "roles": sorted(list(roles)),
            "locations": sorted(list(locations)),
            "skills": sorted(list(skills)),
            "contracts": sorted(list(contracts)),
            "languages": sorted(list(languages)),
        })
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error getting filter options: {e}")

# SNA Endpoints
@app.get("/api/sna/degree_centrality")
async def get_degree_centrality(node_type: Optional[str] = None):
    if cached_graph is None:
        raise HTTPException(status_code=503, detail="Graph data not loaded yet.")
    subgraph = get_subgraph_by_type(cached_graph, node_type)
    return JSONResponse(content=sna.get_degree_centrality(subgraph))

@app.get("/api/sna/betweenness_centrality")
async def get_betweenness_centrality(node_type: Optional[str] = None):
    if cached_graph is None:
        raise HTTPException(status_code=503, detail="Graph data not loaded yet.")
    subgraph = get_subgraph_by_type(cached_graph, node_type)
    return JSONResponse(content=sna.get_betweenness_centrality(subgraph))

@app.get("/api/sna/closeness_centrality")
async def get_closeness_centrality(node_type: Optional[str] = None):
    if cached_graph is None:
        raise HTTPException(status_code=503, detail="Graph data not loaded yet.")
    subgraph = get_subgraph_by_type(cached_graph, node_type)
    return JSONResponse(content=sna.get_closeness_centrality(subgraph))

@app.get("/api/sna/pagerank")
async def get_pagerank(node_type: Optional[str] = None):
    if cached_graph is None:
        raise HTTPException(status_code=503, detail="Graph data not loaded yet.")
    subgraph = get_subgraph_by_type(cached_graph, node_type)
    return JSONResponse(content=sna.get_pagerank(subgraph))

@app.get("/api/sna/communities")
async def get_communities(node_type: Optional[str] = None):
    if cached_graph is None:
        raise HTTPException(status_code=503, detail="Graph data not loaded yet.")
    subgraph = get_subgraph_by_type(cached_graph, node_type)
    return JSONResponse(content=sna.get_communities(subgraph))

@app.get("/api/sna/knowledge_silos")
async def get_knowledge_silos():
    if cached_graph is None:
        raise HTTPException(status_code=503, detail="Graph data not loaded yet.")
    return JSONResponse(content=sna.get_knowledge_sharing_communities(cached_graph))


@app.get("/api/node_types")
async def get_node_types():
    if cached_graph is None:
        raise HTTPException(status_code=503, detail="Graph data not loaded yet.")
    
    types = set(data.get("type") for _, data in cached_graph.nodes(data=True) if data.get("type"))
    return JSONResponse(content=sorted(list(types)))

@app.get("/api/member_subgraph/{member_id}")
async def get_member_subgraph(member_id: str):
    global cached_graph, cached_pos
    if cached_graph is None or cached_pos is None:
        raise HTTPException(status_code=503, detail="Graph data not loaded yet. Please try again in a moment.")
    if not cached_graph.has_node(member_id):
        raise HTTPException(status_code=404, detail=f"Node {member_id} not found.")

    try:
        # Get the neighbors of the selected node
        neighbors = list(cached_graph.neighbors(member_id))
        subgraph_nodes = neighbors + [member_id]
        subgraph = cached_graph.subgraph(subgraph_nodes)

        nodes = []
        edges = []

        for node_id in subgraph.nodes():
            node_data = subgraph.nodes[node_id]
            x, y = cached_pos[node_id]
            nodes.append({
                "id": node_id,
                "label": node_id,
                "x": float(x),
                "y": float(y),
                "size": 10,
                "color": node_data.get("color", "#999"),
                "attributes": node_data
            })

        for i, (source, target, edge_data) in enumerate(subgraph.edges(data=True)):
            edges.append({
                "id": f"e{i}",
                "source": source,
                "target": target,
                "label": edge_data.get("relation", ""),
                "type": "arrow",
                "attributes": edge_data
            })

        graph_data = {"nodes": nodes, "edges": edges}
        return JSONResponse(content=graph_data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error loading subgraph data: {e}")

@app.get("/api/sna/shortest_path")
async def get_shortest_path(source: str, target: str):
    if cached_graph is None:
        raise HTTPException(status_code=503, detail="Graph data not loaded yet.")
    try:
        path = nx.shortest_path(cached_graph, source=source, target=target)
        return JSONResponse(content=path)
    except nx.NetworkXNoPath:
        print(f"No path found between {source} and {target}. This means the nodes exist but are in disconnected components.")
        raise HTTPException(status_code=404, detail=f"Le noeud {source} n'est pas connecté avec {target}.")
    except nx.NodeNotFound as e:
        print(f"Node not found in shortest_path. Available nodes: {list(cached_graph.nodes())}")
        raise HTTPException(status_code=404, detail=str(e))

@app.get("/api/sna/ranked_neighbors")
async def get_ranked_neighbors(node_id: str):
    if cached_graph is None:
        raise HTTPException(status_code=503, detail="Graph data not loaded yet.")
    if not cached_graph.has_node(node_id):
        print(f"Node {node_id} not found in graph. Available nodes: {list(cached_graph.nodes())}")
        raise HTTPException(status_code=404, detail=f"Node {node_id} not found.")
        
    neighbors = list(nx.all_neighbors(cached_graph, node_id))
    if not neighbors:
        return JSONResponse(content={})

    subgraph = cached_graph.subgraph(neighbors + [node_id])
    centrality = nx.degree_centrality(subgraph)
    
    ranked_neighbors = sorted(
        {neighbor: centrality[neighbor] for neighbor in neighbors}.items(),
        key=lambda item: item[1],
        reverse=True
    )
    return JSONResponse(content=dict(ranked_neighbors))



@app.get("/api/sna/dependency_bottlenecks")
async def get_dependency_bottlenecks():
    if cached_graph is None:
        raise HTTPException(status_code=503, detail="Graph data not loaded yet.")
    return JSONResponse(content=sna.get_dependency_bottlenecks(cached_graph))


# Mount the static files for the frontend
app.mount("/", StaticFiles(directory="dashboard/build", html=True), name="static")