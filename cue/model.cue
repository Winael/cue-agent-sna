
#ValueChain: {
    name: string
}

#Portfolio: {
    name:       string
    valueChain: #ValueChain
}

#SAFeTrain: {
    name:      string
    portfolio: #Portfolio
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

#Team: {
    name:    string
    train:   #SAFeTrain
    memberNames: [...string] // Changed from 'members'
    artifactNames: [...string] // New field for artifacts owned by the team
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
        },
    ]

    trains: [
        #SAFeTrain & {
            name:      "Agile Release Train 1"
            portfolio: myOrg.portfolios[0]
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

    teams: [
        #Team & {
            name:  "Team Phoenix"
            train: myOrg.trains[0]
            memberNames: ["Alice", "Bob", "Charlie"]
            artifactNames: ["UserService", "OrderService"] // Team Phoenix owns these artifacts
        },
        #Team & {
            name:  "Team Titan"
            train: myOrg.trains[0]
            memberNames: ["David", "Eve", "Frank"]
            artifactNames: ["PaymentService", "WebApp", "SharedLibrary"] // Team Titan owns these artifacts
        },
    ]
}
