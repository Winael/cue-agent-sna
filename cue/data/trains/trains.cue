package trains

import "github.com/winael/cue-agent-sna/cue/types"

trains: [
    types.#SAFeTrain & {
        name:      "Agile Release Train 1"
        portfolio: types.#Portfolio & {
            name:       "Digital Transformation"
            valueChain: types.#ValueChain & {name: "Product Development"}
        }
        okrNames: ["ART_OKR_1"]
    },
]
