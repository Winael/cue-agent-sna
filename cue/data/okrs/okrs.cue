package okrs

import "github.com/winael/cue-agent-sna/cue/types"

okrs: [name=string]: types.#OKR // New section for all OKRs
okrs: {
    GP_OKR_1: types.#OKR & {
        objective: "Increase customer satisfaction for Grand Public portfolio"
        keyResults: [
            "Achieve 90% CSAT score for key products",
            "Reduce customer support tickets by 20%"
        ]
        owner: "Grand Public"
    }
    DE_OKR_1: types.#OKR & {
        objective: "Accelerate feature delivery for Digital Experience"
        keyResults: [
            "Decrease average lead time by 15%",
            "Increase release frequency to bi-weekly"
        ]
        owner: "Digital Experience"
    }
    Alpha_OKR_1: types.#OKR & {
        objective: "Improve UserService reliability"
        keyResults: [
            "Achieve 99.9% uptime for UserService",
            "Reduce critical bugs in UserService by 50%"
        ]
        owner: "Team Alpha"
    }
    Delta_OKR_1: types.#OKR & {
        objective: "Enhance WebApp performance"
        keyResults: [
            "Reduce page load time by 2 seconds",
            "Improve Lighthouse score to 90+"
        ]
        owner: "Team Delta"
    }
}
