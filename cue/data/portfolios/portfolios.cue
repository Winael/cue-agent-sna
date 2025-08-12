package portfolios

import "github.com/winael/cue-agent-sna/cue/types"

portfolios: [
    types.#Portfolio & {
        name:       "Grand Public"
        valueChain: types.#ValueChain & {name: "Services Numériques"}
        okrNames: ["GP_OKR_1"]
    },
]
