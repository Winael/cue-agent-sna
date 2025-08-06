# Changelog

## 0.2.0 - 2025-08-06

### Added
- **Interactive Dashboard:** Created a new React-based dashboard in the `dashboard/` directory for interactive graph visualization using `sigma.js`.
- **Dashboard Features:**
    - Visualization of the complete organizational graph.
    - Panning and zooming capabilities.
    - Click-to-inspect panel for both nodes and edges, showing detailed attributes.
    - Color-coded nodes based on their type (Member, Team, Service, etc.) for improved readability.
    - A dynamic legend explaining the node color codes.
    - Drag-and-drop functionality to manually reposition nodes.
- **CIR Documentation:** Added a new CIR document (`docs/02_experimentations/02_02_dashboard_interactif.md`) detailing the experimental work and technical challenges overcome during the dashboard's development.

### Changed
- **Graph Generation (`src/build_graph.py`):**
    - Now processes and adds `ValueChain`, `Portfolio`, and `SAFeTrain` entities from the CUE model to the graph.
    - Establishes `belongs_to` relationships between `Teams` and `SAFeTrains`.
- **Project Documentation (`README.md`):**
    - The main `README.md` was updated with instructions on how to run the new interactive dashboard.
    - A dedicated `README.md` was created for the dashboard itself.
- **Python Scripts (`src/`):**
    - Modified `build_graph.py` and `analyze_graph.py` to use direct imports instead of relative ones, allowing them to be run as standalone scripts.

## 0.1.0 - 2025-08-05

### Added
- Initial project setup with virtual environment and core Python dependencies (`ipython`, `langgraph`, `langchain`, `networkx`, `matplotlib`).
- Git repository initialized with `.gitignore`.
- Core project documentation files created: `README.md`, `CHANGELOG.md`, `SECURITY.md`, `LICENSE` (MIT).
- `GEMINI.md` added for LLM interaction guidelines.
- Comprehensive CUE model (`cue/model.cue`) for organizational structure, including:
    - Value Chains, Portfolios, SAFe Trains, Teams.
    - Detailed Members (name, role, skills, seniority, workload, manager relationships).
    - Artifacts (name, type, dependencies).
    - Rituals (name, type, frequency, participants).
    - OKRs (objective, key results, owner).
- Python scripts in `src/`:
    - `load_cue_model.py`: Exports CUE model to JSON.
    - `build_graph.py`: Builds and visualizes the organizational network graph using NetworkX, incorporating all modeled entities and their relationships (teams, members, managers, artifacts, rituals, OKRs).
    - `analyze_graph.py`: Calculates and displays Social Network Analysis (SNA) metrics (degree, betweenness, closeness centrality, average clustering coefficient, community detection, assortativity by role/seniority, PageRank) for the organizational graph.
- Detailed CIR documentation (`docs/02_experimentations/02_01_modele_organisationnel.md`) describing the CUE organizational model.

### Changed
- Refactored CUE model to centralize member definitions for improved management of relationships.
- Updated `src/build_graph.py` to handle the evolving CUE model structure and visualize all new entity types and relationships.
- `README.md` updated with comprehensive usage instructions for CUE model evaluation, graph generation, and graph analysis.
- `docs/01_objectifs.md` updated to reflect progress on formalizing structures and projecting them into an analysis graph.
