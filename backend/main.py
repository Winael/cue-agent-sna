from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from src.load_cue_model import load_model
from src.build_graph import build_graph
import networkx as nx
import asyncio
from watchfiles import awatch

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

@app.get("/api/hello")
async def read_root():
    return {"message": "Hello from FastAPI backend!"}

@app.get("/api/graph_data")
async def get_graph_data():
    global cached_graph, cached_pos
    if cached_graph is None or cached_pos is None:
        raise HTTPException(status_code=503, detail="Graph data not loaded yet. Please try again in a moment.")

    try:
        nodes = []
        edges = []

        for node_id in cached_graph.nodes():
            node_data = cached_graph.nodes[node_id]
            x, y = cached_pos[node_id]
            nodes.append({
                "id": node_id,
                "label": node_id,
                "x": float(x),
                "y": float(y),
                "size": 10, # Default size, can be adjusted
                "color": node_data.get("color", "#999"), # Use color from node_data if available
                "attributes": node_data # Include all node attributes
            })

        for i, (source, target, edge_data) in enumerate(cached_graph.edges(data=True)):
            edges.append({
                "id": f"e{i}",
                "source": source,
                "target": target,
                "label": edge_data.get("relation", ""),
                "type": "arrow", # For directed edges
                "attributes": edge_data # Include all edge attributes
            })

        graph_data = {"nodes": nodes, "edges": edges}
        return JSONResponse(content=graph_data)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error loading graph data: {e}")

@app.get("/api/directory_data")
async def get_directory_data():
    global cached_graph
    if cached_graph is None:
        raise HTTPException(status_code=503, detail="Directory data not loaded yet. Please try again in a moment.")

    try:
        members = []
        for node_id in cached_graph.nodes():
            node_data = cached_graph.nodes[node_id]
            if node_data.get("type") == "Member":
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

# Mount the static files for the frontend
app.mount("/", StaticFiles(directory="dashboard/build", html=True), name="static")