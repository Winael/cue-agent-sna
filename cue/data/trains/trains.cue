package trains

import "github.com/winael/cue-agent-sna/cue/types"

trains: [
    types.#SAFeTrain & {
        name:      "Digital Experience"
        portfolio: types.#Portfolio & {
            name:       "Grand Public"
            valueChain: types.#ValueChain & {name: "Services Numériques"}
        }
        okrNames: ["DE_OKR_1"]
    },
]
