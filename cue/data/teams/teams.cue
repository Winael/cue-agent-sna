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
        artifactNames: [] // Team Alpha owns these artifacts
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
        artifactNames: [] // Team Titan owns these artifacts
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
        artifactNames: [] // Team Titan owns these artifacts
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
        artifactNames: [] // Team Titan owns these artifacts
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
        artifactNames: [] // Team Titan owns these artifacts
        okrNames: []
    },
]
