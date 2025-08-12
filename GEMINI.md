# Gemini Interaction Guidelines

This document provides guidelines for Large Language Models (LLMs) like Gemini interacting with this project.

## Core Principles

1.  **Understand the Goal:** The primary objective is to model and simulate complex organizations using CUE, SNA, and AI agents. Your contributions should align with this goal.
2.  **Respect the Toolchain:** The project relies on a specific set of tools: CUElang, Python (with FastAPI, LangGraph, NetworkX), and Git. Use these tools as intended.
3.  **CUElang First:** All structural and organizational data should be defined in CUE. Avoid hardcoding organizational data in Python or other formats.
4.  **Python for Orchestration:** Python is used to orchestrate the CUE evaluations, run SNA on the resulting data, and manage the AI agents. The **FastAPI** backend (`backend/main.py`) serves the interactive dashboard and exposes a REST API for graph data and SNA metrics.
5.  **LangGraph for Agents:** The AI agents should be implemented using LangGraph to create a flexible and extensible agentic system.
6.  **SNA for Analysis:** Use the NetworkX library to perform social network analysis on the data extracted from the CUE models.
7.  **Iterative and Experimental:** This is a research project. Be prepared to experiment, iterate, and document the process in the `docs/02_experimentations` directory.

## Workflow

1.  **Model in CUE:** Define the organizational structure, roles, responsibilities, and relationships in `.cue` files.
2.  **Process in Python:** The FastAPI backend automatically loads and processes the CUE model.
3.  **Interact via Dashboard:** The primary interaction is now through the web dashboard, which calls the FastAPI backend for data and analysis.
    - **Filter System:** The dashboard now includes a comprehensive filter system, allowing users to dynamically filter members based on various attributes (roles, location, skills, contract, languages) in both the graph and directory views.
4.  **Analyze with NetworkX:** The backend uses NetworkX to perform SNA calculations when requested by the frontend.
5.  **Simulate with LangGraph:** Use the AI agents to interact with the graph, propose changes, and simulate their impact.
6.  **Feedback Loop:** The results of the simulation can be used to inform changes to the CUE models, closing the loop.

## Example CUE command

To validate the CUE model:

```bash
cue eval cue/main.cue
```