package types

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
    team:     string
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
    artifactNames: [...string] // New field for artifacts owned by the team
    okrNames: [...string] // New field for OKRs associated with the Team
}