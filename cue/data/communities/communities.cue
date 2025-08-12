package communities

import "github.com/winael/cue-agent-sna/cue/types"

communities: [name=string]: types.#CommunityOfPractice

communities: {
    "Frontend Guild": types.#CommunityOfPractice & {
        name: "Frontend Guild",
        topic: "Frontend Development",
        facilitator: "Clara",
        communityRelations: [
            {
                source: "Clara",
                target: "Yassine",
                type: "mentors",
                context: "Frontend Best Practices"
            },
            {
                source: "Nora",
                target: "Farid",
                type: "collaborates",
                context: "UI/UX Integration"
            }
        ]
    },
   "Agile Practitioners": types.#CommunityOfPractice & {
        name: "Agile Practitioners",
        topic: "Agile Methodologies",
        facilitator: "Bruno",
        communityRelations: [
            {
                source: "Bruno",
                target: "Pierre",
                type: "leads",
                context: "Scrum Master Coaching"
            },
            {
                source: "Alice",
                target: "Thierry",
                type: "collaborates",
                context: "Product Strategy Alignment"
            }
        ]
    },
    "DevOps": types.#CommunityOfPractice & {
        name: "DevOps",
        topic: "DevOps Culture and Practices",
        facilitator: "Bruno",
        communityRelations: [
            {
                source: "Nassim",
                target: "Kevin",
                type: "mentors",
                context: "CI/CD Pipelines"
            },
            {
                source: "Sonia",
                target: "Anna",
                type: "shares_knowledge",
                context: "Monitoring Dashboards"
            },
            {
                source: "Leo",
                target: "Lina",
                type: "collaborates",
                context: "Security in Integration"
            }
        ]
    }
}