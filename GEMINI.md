# Gemini Interaction Guidelines

This document provides guidelines for Large Language Models (LLMs) like Gemini interacting with this project.

## Core Principles

1.  **Understand the Goal:** The primary objective is to model and simulate complex organizations using CUE, SNA, and AI agents. Your contributions should align with this goal.
2.  **Respect the Toolchain:** The project relies on a specific set of tools: CUElang, Python (with LangGraph, NetworkX), and Git. Use these tools as intended.
3.  **CUElang First:** All structural and organizational data should be defined in CUE. Avoid hardcoding organizational data in Python or other formats.
4.  **Python for Orchestration:** Python is used to orchestrate the CUE evaluations, run SNA on the resulting data, and manage the AI agents.
5.  **LangGraph for Agents:** The AI agents should be implemented using LangGraph to create a flexible and extensible agentic system.
6.  **SNA for Analysis:** Use the NetworkX library to perform social network analysis on the data extracted from the CUE models.
7.  **Iterative and Experimental:** This is a research project. Be prepared to experiment, iterate, and document the process in the `docs/02_experimentations` directory.

## Workflow

1.  **Model in CUE:** Define the organizational structure, roles, responsibilities, and relationships in `.cue` files.
2.  **Export from CUE:** Use the `cue export` command to generate JSON data from the CUE models.
3.  **Process in Python:** Load the JSON data into Python.
4.  **Analyze with NetworkX:** Build a graph from the data and perform SNA.
5.  **Simulate with LangGraph:** Use the AI agents to interact with the graph, propose changes, and simulate their impact.
6.  **Feedback Loop:** The results of the simulation can be used to inform changes to the CUE models, closing the loop.

## Example CUE command

To export the CUE model to JSON:

```bash
cue export model.cue --out json > model.json
```
