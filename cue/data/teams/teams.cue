package teams

import "github.com/winael/cue-agent-sna/cue/types"

teams: [
    types.#Team & {
        name: "Team Alpha"
        type: "Scrum UI" 
        train: types.#SAFeTrain & {
            name:      "Digital Experience"
            portfolio: types.#Portfolio & {
                name:       "Grand Public"
                valueChain: types.#ValueChain & {name: "Services Numériques"}
            }
        }
        artifactNames: ["artifact-alpha-web-app", "artifact-alpha-design-system", "artifact-alpha-e2e-tests"] // Team Alpha owns these artifacts
        okrNames: []
    },
    types.#Team & {
        name: "Team Delta"
        type: "Composant API"
        train: types.#SAFeTrain & {
            name:      "Digital Experience"
            portfolio: types.#Portfolio & {
                name:       "Grand Public"
                valueChain: types.#ValueChain & {name: "Services Numériques"}
            }
        }
        artifactNames: ["artifact-delta-core-api", "artifact-delta-auth-service", "artifact-delta-api-gateway"] // Team Delta owns these artifacts
        okrNames: []
    },
    types.#Team & {
        name: "Team Gamma"
        type: "Exploratoire / Interco"
        train: types.#SAFeTrain & {
            name:      "Digital Experience"
            portfolio: types.#Portfolio & {
                name:       "Grand Public"
                valueChain: types.#ValueChain & {name: "Services Numériques"}
            }
        }
        artifactNames: ["artifact-gamma-poc-framework", "artifact-gamma-integration-toolkit", "artifact-gamma-data-explorer"] // Team Gamma owns these artifacts
        okrNames: []
    },
    types.#Team & {
        name: "Team Omega"
        type: "Intégration"
        train: types.#SAFeTrain & {
            name:      "Digital Experience"
            portfolio: types.#Portfolio & {
                name:       "Grand Public"
                valueChain: types.#ValueChain & {name: "Services Numériques"}
            }
        }
        artifactNames: ["artifact-omega-integration-platform", "artifact-omega-automated-tests-suite", "artifact-omega-deployment-scripts"] // Team Omega owns these artifacts
        okrNames: []
    },
    types.#Team & {
        name: "Team Sigma"
        type: "Platform Team"
        train: types.#SAFeTrain & {
            name:      "Digital Experience"
            portfolio: types.#Portfolio & {
                name:       "Grand Public"
                valueChain: types.#ValueChain & {name: "Services Numériques"}
            }
        }
        artifactNames: ["artifact-sigma-ci-cd-pipeline", "artifact-sigma-monitoring-stack", "artifact-sigma-security-scanner", "artifact-sigma-kubernetes-platform"] // Team Sigma owns these artifacts
        okrNames: []
    },
]
