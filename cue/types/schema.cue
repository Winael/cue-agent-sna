package types

#Relation: {
	target: string
	weight?: number & >= 0 & <= 1
	startDate?: string // format YYYY-MM-DD
	channel?: string
    context?: string
}

#CommunityRelation: {
	source: string // Name of the member initiating the relation
	target: string // Name of the member receiving the relation
	type: "mentors" | "collaborates" | "shares_knowledge" | "leads"
	weight?: number & >= 0 & <= 1
	startDate?: string // format YYYY-MM-DD
	context?: string // Specific context of the relation within the community
}

#CommunityOfPractice: {
	name: string
	topic: string
	facilitator?: string // Name of the member facilitating
	communityRelations?: [...#CommunityRelation] // Relations specific to this community
}

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
    name:           string
    role:           string
    skills:         [...string]
    seniority:      int & >=1 & <=3
    workload:       number & >=0 & <=1
    manager:        string | null // New field for manager's name
    contract:       "CDI" | "ESN" | "Freelance"
    available:      bool
    tenureMonths:   int
    location:       string
    language:       [...string]
    active:         bool
    team:           string
    communities?:   [...string] // New field for communities of practice
    pairedWith?:    [...#Relation] // New field for members this person pairs with
    mentors?:       [...#Relation] // New field for members this person mentors
    blockedBy?:     [...#Relation]
    askAdviceFrom?: [...#Relation]
    talksTo?:       [...#Relation]
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
    type:    string
    train:   #SAFeTrain
    artifactNames: [...string] // New field for artifacts owned by the team
    okrNames: [...string] // New field for OKRs associated with the Team
}
