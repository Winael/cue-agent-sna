
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
    name: string
    role: string
}

#Team: {
    name:    string
    train:   #SAFeTrain
    members: [...#Member]
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

    teams: [
        #Team & {
            name:  "Team Phoenix"
            train: myOrg.trains[0]
            members: [
                #Member & {name: "Alice", role: "Product Owner"},
                #Member & {name: "Bob", role: "Scrum Master"},
                #Member & {name: "Charlie", role: "Developer"},
            ]
        },
        #Team & {
            name:  "Team Titan"
            train: myOrg.trains[0]
            members: [
                #Member & {name: "David", role: "Product Owner"},
                #Member & {name: "Eve", role: "Developer"},
                #Member & {name: "Frank", role: "Developer"},
            ]
        },
    ]
}
