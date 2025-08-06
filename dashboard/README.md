# Organizational Network Dashboard

This project provides an interactive dashboard for visualizing and exploring the organizational network graph.

## Features

- **Interactive Graph:** The dashboard displays the organizational network using the sigma.js library, allowing for smooth panning and zooming.
- **Node and Edge Details:** Click on any node (e.g., a team member, a service) or any edge (a relationship) to see its detailed properties in a side panel.
- **Color-Coded Nodes:** Nodes are color-coded by their type (e.g., Member, Team, Service) to provide a clear visual distinction.
- **Legend:** A legend is provided to explain the color-coding of the different node types.
- **Dynamic Data Loading:** The graph data is loaded from a `graph_data.json` file, which can be regenerated from the CUE model.

## Available Scripts

In the project directory, you can run:

### `npm start`

Runs the app in the development mode.
Open [http://localhost:3000](http://localhost:3000) to view it in your browser.

The page will reload when you make changes.
You may also see any lint errors in the console.

### `npm test`

Launches the test runner in the interactive watch mode.

### `npm run build`

Builds the app for production to the `build` folder.