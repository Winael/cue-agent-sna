package teams

import "github.com/winael/cue-agent-sna/cue/types"

teams: [
    types.#Team & {
        name:  "Team Phoenix"
        train: types.#SAFeTrain & {
            name:      "Agile Release Train 1"
            portfolio: types.#Portfolio & {
                name:       "Digital Transformation"
                valueChain: types.#ValueChain & {name: "Product Development"}
            }
        }
        artifactNames: ["UserService", "OrderService"] // Team Phoenix owns these artifacts
        okrNames: ["Phoenix_OKR_1"]
    },
    types.#Team & {
        name:  "Team Titan"
        train: types.#SAFeTrain & {
            name:      "Agile Release Train 1"
            portfolio: types.#Portfolio & {
                name:       "Digital Transformation"
                valueChain: types.#ValueChain & {name: "Product Development"}
            }
        }
        artifactNames: ["PaymentService", "WebApp", "SharedLibrary"] // Team Titan owns these artifacts
        okrNames: ["Titan_OKR_1"]
    },
]
