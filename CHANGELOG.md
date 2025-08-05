# Changelog

## 0.2.0 - 2025-08-05

### Added
- Added `src/analyze_graph.py` for calculating and displaying Social Network Analysis (SNA) metrics (degree, betweenness, closeness centrality).
- Created `docs/02_experimentations/02_01_modele_organisationnel.md` to provide detailed documentation of the CUE organizational model.

### Changed
- Updated `README.md` with comprehensive usage instructions for CUE model evaluation, graph generation, and graph analysis.
- Updated `docs/01_objectifs.md` to reflect progress on formalizing structures and projecting them into an analysis graph.

## 0.1.0 - 2025-08-05

### Added
- Initial project setup with virtual environment and core dependencies.
- Git repository initialization.
- Basic documentation structure (`docs/`, `README.md`, `CHANGELOG.md`, `SECURITY.md`, `LICENSE`).
- `GEMINI.md` for LLM interaction guidelines.
- CUE model for organizational structure:
    - Value Chains, Portfolios, SAFe Trains, Teams.
    - Detailed Members (skills, seniority, workload, manager relationships).
    - Artifacts (type, dependencies).
    - Rituals (type, frequency, participants).
    - OKRs (objective, key results, owner).
- Python scripts (`src/load_cue_model.py`, `src/build_graph.py`) to:
    - Load CUE model and export to JSON.
    - Build and visualize organizational network graph with NetworkX, including all modeled entities and relationships.

### Changed
- Refactored CUE model to centralize member definitions for easier management of relationships.
- Updated `src/build_graph.py` to handle new CUE model structure and visualize all new entity types and relationships.
