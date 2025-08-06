package portfolios

import "github.com/winael/cue-agent-sna/cue/types"

portfolios: [
    types.#Portfolio & {
        name:       "Digital Transformation"
        valueChain: types.#ValueChain & {name: "Product Development"}
        okrNames: ["Portfolio_OKR_1"]
    },
]
