
#ValueChain: {
    name: string
}

#OKR: {
    objective: string
    keyResults: [...string]
    owner: string // Name of the entity (Member, Team, SAFeTrain, Portfolio) that owns this OKR
}

#Portfolio: {
    name:       string
    valueChain: #ValueChain
    okrNames: [...string] // New field for OKRs associated with the Portfolio
}

#SAFeTrain: {
    name:      string
    portfolio: #Portfolio
    okrNames: [...string] // New field for OKRs associated with the SAFe Train
}

#Member: {
    name:     string
    role:     string
    skills:   [...string]
    seniority: "Junior" | "Mid" | "Senior"
    workload:  number & >=0 & <=1
    manager:   string | null // New field for manager's name
}

#Artifact: {
    name: string
    type: "service" | "application" | "library"
    dependsOn: [...string] // Names of other artifacts this one depends on
}

#Ritual: {
    name: string
    type: "Daily Scrum" | "Sprint Planning" | "Sprint Review" | "Sprint Retrospective" | "PI Planning" | "Scrum of Scrums"
    frequency: "daily" | "weekly" | "bi-weekly" | "monthly" | "quarterly"
    participants: [...string] // Names of members participating in this ritual
}

#Team: {
    name:    string
    train:   #SAFeTrain
    memberNames: [...string] // Changed from 'members'
    artifactNames: [...string] // New field for artifacts owned by the team
    okrNames: [...string] // New field for OKRs associated with the Team
}

myOrg: {
    valueChains: [
        #ValueChain & {
            name: "Product Development"
        },
    ]

    portfolios: [
        #Portfolio & {
            name:       "Digital Transformation"
            valueChain: myOrg.valueChains[0]
            okrNames: ["Portfolio_OKR_1"]
        },
    ]

    trains: [
        #SAFeTrain & {
            name:      "Agile Release Train 1"
            portfolio: myOrg.portfolios[0]
            okrNames: ["ART_OKR_1"]
        },
    ]

    members: [name=string]: #Member // New section for all members
    members: {
        Alice:   #Member & {name: "Alice", role: "Product Owner", skills: ["Product Management", "Agile"], seniority: "Senior", workload: 0.8, manager: null}
        Bob:     #Member & {name: "Bob", role: "Scrum Master", skills: ["Agile", "Coaching"], seniority: "Mid", workload: 0.9, manager: "Alice"}
        Charlie: #Member & {name: "Charlie", role: "Developer", skills: ["Python", "Go", "CUE"], seniority: "Junior", workload: 1.0, manager: "Bob"}
        David:   #Member & {name: "David", role: "Product Owner", skills: ["Product Management", "UX"], seniority: "Senior", workload: 0.7, manager: null}
        Eve:     #Member & {name: "Eve", role: "Developer", skills: ["JavaScript", "React", "Node.js"], seniority: "Mid", workload: 0.9, manager: "David"}
        Frank:   #Member & {name: "Frank", role: "Developer", skills: ["Python", "Django", "DevOps"], seniority: "Senior", workload: 1.0, manager: "David"}
    }

    artifacts: [name=string]: #Artifact // New section for all artifacts
    artifacts: {
        UserService: #Artifact & {name: "UserService", type: "service", dependsOn: []}
        OrderService: #Artifact & {name: "OrderService", type: "service", dependsOn: ["UserService"]}
        PaymentService: #Artifact & {name: "PaymentService", type: "service", dependsOn: ["UserService"]}
        WebApp: #Artifact & {name: "WebApp", type: "application", dependsOn: ["OrderService", "PaymentService"]}
        SharedLibrary: #Artifact & {name: "SharedLibrary", type: "library", dependsOn: []}
    }

    rituals: [name=string]: #Ritual // New section for all rituals
    rituals: {
        PhoenixDaily: #Ritual & {name: "Phoenix Daily", type: "Daily Scrum", frequency: "daily", participants: ["Alice", "Bob", "Charlie"]}
        TitanDaily: #Ritual & {name: "Titan Daily", type: "Daily Scrum", frequency: "daily", participants: ["David", "Eve", "Frank"]}
        ART_Sync: #Ritual & {name: "ART Sync", type: "Scrum of Scrums", frequency: "weekly", participants: ["Alice", "David", "Bob"]}
        PI_Planning_Q3: #Ritual & {name: "PI Planning Q3", type: "PI Planning", frequency: "quarterly", participants: ["Alice", "Bob", "Charlie", "David", "Eve", "Frank"]}
    }

    okrs: [name=string]: #OKR // New section for all OKRs
    okrs: {
        Portfolio_OKR_1: #OKR & {
            objective: "Increase customer satisfaction for Digital Transformation portfolio"
            keyResults: [
                "Achieve 90% CSAT score for key products",
                "Reduce customer support tickets by 20%"
            ]
            owner: "Digital Transformation"
        }
        ART_OKR_1: #OKR & {
            objective: "Accelerate feature delivery for ART 1"
            keyResults: [
                "Decrease average lead time by 15%",
                "Increase release frequency to bi-weekly"
            ]
            owner: "Agile Release Train 1"
        }
        Phoenix_OKR_1: #OKR & {
            objective: "Improve UserService reliability"
            keyResults: [
                "Achieve 99.9% uptime for UserService",
                "Reduce critical bugs in UserService by 50%"
            ]
            owner: "Team Phoenix"
        }
        Titan_OKR_1: #OKR & {
            objective: "Enhance WebApp performance"
            keyResults: [
                "Reduce page load time by 2 seconds",
                "Improve Lighthouse score to 90+"
            ]
            owner: "Team Titan"
        }
    }

    teams: [
        #Team & {
            name:  "Team Phoenix"
            train: myOrg.trains[0]
            memberNames: ["Alice", "Bob", "Charlie"]
            artifactNames: ["UserService", "OrderService"] // Team Phoenix owns these artifacts
            okrNames: ["Phoenix_OKR_1"]
        },
        #Team & {
            name:  "Team Titan"
            train: myOrg.trains[0]
            memberNames: ["David", "Eve", "Frank"]
            artifactNames: ["PaymentService", "WebApp", "SharedLibrary"] // Team Titan owns these artifacts
            okrNames: ["Titan_OKR_1"]
        },
    ]
}
