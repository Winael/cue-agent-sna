package rituals

import "github.com/winael/cue-agent-sna/cue/types"

rituals: [name=string]: types.#Ritual // New section for all rituals
rituals: {
    PhoenixDaily: types.#Ritual & {name: "Phoenix Daily", type: "Daily Scrum", frequency: "daily", participants: ["Alice", "Bob", "Charlie"]}
    TitanDaily: types.#Ritual & {name: "Titan Daily", type: "Daily Scrum", frequency: "daily", participants: ["David", "Eve", "Frank"]}
    ART_Sync: types.#Ritual & {name: "ART Sync", type: "Scrum of Scrums", frequency: "weekly", participants: ["Alice", "David", "Bob"]}
    PI_Planning_Q3: types.#Ritual & {name: "PI Planning Q3", type: "PI Planning", frequency: "quarterly", participants: ["Alice", "Bob", "Charlie", "David", "Eve", "Frank"]}
}
