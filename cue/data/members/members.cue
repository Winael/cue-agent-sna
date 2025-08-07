package members

import "github.com/winael/cue-agent-sna/cue/types"

members: [name=string]: types.#Member // New section for all members
members: {
    Alice:   types.#Member & {name: "Alice", role: "Product Owner", skills: ["Product Management", "Agile"], seniority: "Senior", workload: 0.8, manager: null, team: "Team Phoenix"}
    Bob:     types.#Member & {name: "Bob", role: "Scrum Master", skills: ["Agile", "Coaching"], seniority: "Mid", workload: 0.9, manager: "Alice", team: "Team Phoenix"}
    Charlie: types.#Member & {name: "Charlie", role: "Developer", skills: ["Python", "Go", "CUE"], seniority: "Junior", workload: 1.0, manager: "Bob", team: "Team Phoenix"}
    Didier:  types.#Member & {name: "Didier", role: "UX Designer", skills: ["UX Design", "Design Sprint", "Vision produit"], seniority: "Mid", workload: 0.8, manager: null, team: "Team Phoenix"}
    David:   types.#Member & {name: "David", role: "Product Owner", skills: ["Product Management", "UX"], seniority: "Senior", workload: 0.7, manager: null, team: "Team Titan"}
    Eve:     types.#Member & {name: "Eve", role: "Developer", skills: ["JavaScript", "React", "Node.js"], seniority: "Mid", workload: 0.9, manager: "David", team: "Team Titan"}
    Frank:   types.#Member & {name: "Frank", role: "Developer", skills: ["Python", "Django", "DevOps"], seniority: "Senior", workload: 1.0, manager: "David", team: "Team Titan", pairedWith: ["Gladys"]}
    Gladys:  types.#Member & {name: "Gladys", role: "Developer", skills: ["React", "VueJS", "VanillaJS"], seniority: "Senior", workload: 1.0, manager: "David", team: "Team Titan", pairedWith: ["Franck"]}
    Henri:   types.#Member & {name: "Henri", role: "Ops", skills: ["CICD", "Linux"], seniority: "Senior", workload: 1.0, manager: null, team: "Team Titan"}
}
