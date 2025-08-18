# Changelog

## 0.4.0 - 2025-08-18

### Added
- **Enhanced Dashboard Views:**
    - "People View" now includes organizational nodes (Team, SAFeTrain, Portfolio, ValueChain, CommunityOfPractice) in addition to members.
    - "Architecture View" now displays only artifact nodes (service, application, library).

### Changed
- **UI/UX Improvements:**
    - Adjusted the positioning of the legend block to prevent overlap with other UI elements.
    - Reduced header height and adjusted various font sizes (h1, buttons, filter group, dropdown menus) for improved UI compactness and readability.
- **Documentation Updates:**
    - `docs/04_credit_impot_recherche.md` updated to reflect new R&D activities related to interactive views and detailed artifact modeling.
    - `docs/02_experimentations/02_01_modele_organisationnel.md` updated to include detailed attributes for artifacts.
    - `docs/02_experimentations/02_02_dashboard_interactif.md` updated to explicitly mention the new `get_dependency_bottlenecks` endpoint.

## 0.3.2 - 2025-08-12

### Added
- **New SNA Queries:** Implemented new SNA queries for Agile and DevOps diagnostics:
    - Knowledge Silo Detection (based on knowledge-sharing relationships).
    - Dependency Bottleneck Identification (for artifacts/services).

### Changed
- **Graph Color Palette:** Updated graph node color palette for better readability and contrast.

## 0.3.1 - 2025-08-12

### Added
- **Interactive Filter System:** Implemented a new filter system for members in both graph and directory views, allowing filtering by roles, locations, skills, contracts, and languages.

### Changed
- **Filter UI:** Updated filter user interface to use multi-select dropdowns (`react-select`) for improved user experience.
- **Filter Layout:** Adjusted filter bar layout for horizontal display with scrolling.

### Fixed
- **Filter Dropdown Display:** Resolved z-index issue causing filter dropdowns to appear behind the graph.

## 0.3.0 - 2025-08-12

### Added
- **Communities of Practice:** Introduced new CUE schemas (`#CommunityOfPractice`, `#CommunityRelation`, `#Relation`) to formally model communities and detailed interpersonal relationships (mentoring, collaboration, etc.).

### Changed
- **CUE Model Refactoring:** Overhauled the entire CUE model for greater clarity and detail. This includes:
    - Adding new fields to the `#Member` schema (e.g., `contract`, `tenureMonths`, `location`, `active`).
    - Enhancing relationship definitions to be more expressive.
- **Graph Building Logic:** Updated `src/build_graph.py` to be compatible with the new, more detailed CUE model structure.
- **CUE Data Loading:** Switched from `cue export` to `cue eval` in `src/load_cue_model.py` for more robust and comprehensive data evaluation.
- **Documentation:** Updated `docs/02_experimentations/02_01_modele_organisationnel.md` and `docs/04_credit_impot_recherche.md` to reflect the new CUE model and its R&D implications.

### Fixed
- **Graph Rendering:** Fixed a critical bug in `dashboard/src/Graph.js` that prevented the graph from rendering due to an incorrect property access (`edge.relation` instead of `edge.label`).

## 0.2.5 - 2025-08-08

### Added
- **Member-Centric Analysis:** Implemented new features for in-depth analysis of individual members in the graph.
- **Isolate Member View:** Added a button to isolate a selected member and their direct relationships, creating a focused subgraph view.
- **Shortest Path Analysis:** Implemented a feature to find and display the shortest path between two selected members.
- **Ranked Neighbors:** Added a feature to rank the neighbors of a selected member by their degree centrality.

### Changed
- **Backend API:** Added new endpoints in `backend/main.py` to support the new member-centric analysis features:
    - `/api/member_subgraph/{member_id}`
    - `/api/sna/shortest_path`
    - `/api/sna/ranked_neighbors`
- **Frontend Interaction:** Major updates to `dashboard/src/Graph.js` to handle the new interaction modes (selecting nodes for path analysis, displaying subgraphs) and to call the new API endpoints.
- **Documentation:** 
    - Updated `docs/02_experimentations/02_02_dashboard_interactif.md` to document the new member-centric analysis features.
    - Updated `docs/04_credit_impot_recherche.md` to include the new advanced visualization features as part of the R&D activities.

### Fixed
- **Node Dragging:** Fixed a bug where dragging a node would also pan the entire graph, by using `e.preventSigmaDefault()` in the event handler.

## 0.2.4 - 2025-08-07

### Added
- **Interactive SNA Queries:** Implemented a new SNA analysis panel in the dashboard.
- **SNA Metrics:** Added backend API endpoints and frontend buttons for Degree, Betweenness, and Community detection analyses.
- **Contextual Analysis:** SNA queries are now context-aware, focusing primarily on "Member" nodes to provide more relevant insights.
- **Dynamic Visualization:** The graph now dynamically updates to show only the nodes and edges relevant to the performed analysis, with a "Reset" button to return to the full view.
- **Analysis Results Panel:** A new panel displays key results and a description for each SNA metric, making the tool more educational.
- **Tooltips:** Added tooltips to SNA buttons to explain the purpose of each analysis at a glance.

### Changed
- **Refactored Frontend:** Major refactoring of the `Graph.js` component to handle dynamic graph filtering, view resetting, and results display.
- **Refactored Backend:** SNA endpoints in `backend/main.py` now accept a `node_type` parameter to filter the graph before analysis.

### Fixed
- **Community Analysis:** Fixed a bug where the community detection analysis was not correctly processed or visualized.
- **Node Interactivity:** Re-implemented node click and drag-and-drop functionalities which were lost during a previous refactoring.
- **API Path:** Corrected the API path for the directory data in the frontend.
- **Python Imports:** Fixed `ModuleNotFoundError` in the backend by using relative imports within the `src` package.

## 0.2.3 - 2025-08-07

### Added
- **Dynamic CUE Data Reloading:** Implemented automatic reloading of graph data in the FastAPI backend when CUE files in the `cue/` directory are modified, using `watchfiles`.
- **Explicit Member Relationships:** Added `pairedWith` and `mentors` fields to the `#Member` schema in `cue/types/schema.cue` and updated `src/build_graph.py` to process these explicit relationships, creating corresponding edges in the graph.

### Changed
- **Member Relationship Handling:** Modified `src/build_graph.py` to remove implicit "collaborates_with" edges between members of the same team, enforcing explicit relationship definitions.
- **Documentation:** Updated `README.md` and `docs/02_experimentations/02_02_dashboard_interactif.md` to reflect the dynamic CUE data reloading and the new explicit member relationships.

### Fixed
- **Backend Reload Error:** Resolved `NameError: name 'asyncio' is not defined` in `backend/main.py` by ensuring `asyncio` is correctly imported and used for background tasks.

## 0.2.2 - 2025-08-07

### Changed
- **Frontend/Backend Integration:** Transitioned from a separate frontend development server with proxy to serving the React frontend directly from the FastAPI backend. This eliminates proxy and CORS issues, simplifying deployment.
    - Removed `dashboard/src/setupProxy.js`.
    - Removed `proxy` configuration from `dashboard/package.json`.
    - Updated `backend/main.py` to serve static files from `dashboard/build`.
    - Modified frontend API calls in `dashboard/src/App.js`, `dashboard/src/Graph.js`, and `dashboard/src/Directory.js` to remove the `/api` prefix.
- **Documentation:** Updated `README.md` and `docs/02_experimentations/02_02_dashboard_interactif.md` to reflect the new frontend/backend serving mechanism and simplified running instructions.
- **Dependencies:** Added `fastapi`, `uvicorn`, and `watchfiles` to `requirements.txt` for the FastAPI backend.
- **Build Process:** `src/build_graph.py` no longer generates static `directory_data.json` and `graph_data.json` files, as data is now dynamically served by the backend.

### Fixed
- **Frontend 504 Errors:** Resolved persistent 504 (Gateway Timeout) and JSON parsing errors in the frontend by directly serving the React build from the FastAPI backend, bypassing proxy issues.

## 0.2.1 - 2025-08-06

### Fixed
- **Dashboard Compilation:** Resolved multiple compilation errors in the React dashboard (`src/Graph.js`, `src/App.js`, `src/Directory.js`) related to undefined functions and `no-undef` issues.
- **Graph Rendering:** Fixed "Sigma: Container has no height" error by ensuring proper height propagation through CSS (`src/App.css`, `src/index.css`) and component props.
- **Sigma.js Compatibility:** Addressed `TypeError: this.camera.on is not a function` by removing an unnecessary `sigma.setCamera` call and setting `allowInvalidContainer: true` in Sigma.js configuration.

### Added
- **Directory Tab:** Implemented a new "Annuaire" tab in the dashboard (`src/Directory.js`) to display a detailed list of members from `directory_data.json`.
- **CIR Documentation:** Added a new comprehensive documentation file (`docs/04_credit_impot_recherche.md`) detailing the project's eligibility for the Crédit Impôt Recherche.
- **CUE Model Refactoring:** Restructured the CUE organizational model for improved maintainability and more efficient data management. This includes modularizing the CUE definitions into `cue/data/`, introducing `cue/main.cue` as the primary entry point, and defining schemas in `cue/types/`.

### Changed
- **Dashboard Documentation:** Updated `docs/02_experimentations/02_02_dashboard_interactif.md` to reflect the addition of the "Annuaire" tab and the resolution of rendering issues.
- **README.md:** Updated the main `README.md` to include a link to the new CIR documentation and revised instructions for running the dashboard.
- **CUE Model Structure:** Replaced `cue/model.cue` with a new modular structure under `cue/` for better organization and maintainability.
- **Python Scripts:** Updated `src/build_graph.py` and `src/load_cue_model.py` to adapt to the new CUE model structure.


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
