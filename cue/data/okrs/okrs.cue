package okrs

import "github.com/winael/cue-agent-sna/cue/types"

okrs: [name=string]: types.#OKR // New section for all OKRs
okrs: {
    Portfolio_OKR_1: types.#OKR & {
        objective: "Increase customer satisfaction for Digital Transformation portfolio"
        keyResults: [
            "Achieve 90% CSAT score for key products",
            "Reduce customer support tickets by 20%"
        ]
        owner: "Digital Transformation"
    }
    ART_OKR_1: types.#OKR & {
        objective: "Accelerate feature delivery for ART 1"
        keyResults: [
            "Decrease average lead time by 15%",
            "Increase release frequency to bi-weekly"
        ]
        owner: "Agile Release Train 1"
    }
    Phoenix_OKR_1: types.#OKR & {
        objective: "Improve UserService reliability"
        keyResults: [
            "Achieve 99.9% uptime for UserService",
            "Reduce critical bugs in UserService by 50%"
        ]
        owner: "Team Phoenix"
    }
    Titan_OKR_1: types.#OKR & {
        objective: "Enhance WebApp performance"
        keyResults: [
            "Reduce page load time by 2 seconds",
            "Improve Lighthouse score to 90+"
        ]
        owner: "Team Titan"
    }
}
