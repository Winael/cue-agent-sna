package members

import "github.com/winael/cue-agent-sna/cue/types"

members: [name=string]: types.#Member // New section for all members
members: {
    Alice:   types.#Member & {
        name:           "Alice" 
        role:           "Product Owner" 
        skills: [
            "Product Management", 
            "Agile",
            "Roadmapping"
        ]
        seniority:      3
        workload:       0.8
        available:      true
        contract:       "CDI"
        tenureMonths:   36
        location:      "Paris"
        language:       ["FR"]
        active:         true
        manager:        null
        team:           "Team Alpha"
        communities:    ["Agile Practitioners"]
    }
    Bruno:   types.#Member & {
        name:           "Bruno"
        role:           "Scrum Master"
        seniority:      3
        skills: [
            "Facilitation",
            "Team Coaching"
        ]
        contract:       "Freelance"
        workload:       1
        available:      true
        tenureMonths:   24 
        location:       "Paris"
        language:       ["FR"]
        active:         true
        manager:        null
        team:           "Team Alpha"
        communities:    ["Agile Practitioners", "DevOps"]
        mentors:        [
            {
                target: "Emma"
                weight: 0.7
                startDate: "2025-02-01"
            }
        ]
    }  
    Clara:   types.#Member & {
        name:           "Clara"
        role:           "Developer"
        seniority:      3
        skills: [
            "Frontend", 
            "React"
        ]
        contract:       "CDI"
        workload:       1
        available:      true
        tenureMonths:   18 
        location:       "Remote"
        language:       ["FR"]
        active:         true
        manager:        null
        team:           "Team Alpha"
        communities:    ["Frontend Guild", "DevOps"]
        pairedWith:     [
            {
                target: "David"
                weight: 0.8    
                startDate: "2025-01-10"
            }
        ]
        askAdviceFrom:  [
            {
                target: "Alice"
                weight: 0.5
            }
        ]
        talksTo:        [
            {
                target: "Farid"
                weight: 0.4
                channel: "UX Workshop"
            }
        ]
    }
    David:   types.#Member & {
        name:           "David"
        role:           "Developer"
        seniority:      2
        skills: [
            "Frontend", 
            "Vue.js"
        ]
        contract:       "ESN"
        workload:       .9
        available:      true
        tenureMonths:   12 
        location:       "Remote"
        language:       ["FR"]
        active:         true
        manager:        null
        team:           "Team Alpha"
        communities:    ["Frontend Guild", "DevOps"]
        pairedWith: [
            {
                target: "Clara"
                weight: 0.8    
                startDate: "2025-01-10"
            }
        ]
        blockedBy: [
            {
                target: "Emma"
                weight: 0.6
            }
        ]
    }
    Emma:   types.#Member & {
        name:           "Emma"
        role:           "Tester"
        seniority:      1
        skills: [
            "QA", 
            "Test Automation"
        ]
        contract:       "CDI"
        workload:       1
        available:      true
        tenureMonths:   6 
        location:       "Paris"
        language:       ["FR"]
        active:         true
        manager:        null
        team:           "Team Alpha"
        communities:    ["DevOps"]
    }
    Farid:   types.#Member & {
        name:           "Farid"
        role:           "UX Designer"
        seniority:      1
        skills: [
            "UX", 
            "Design Thinking"
        ]
        contract:       "Freelance"
        workload:       .8
        available:      true
        tenureMonths:   9 
        location:       "Paris"
        language:       ["FR", "EN"]
        active:         true
        manager:        null
        team:           "Team Alpha"
        communities:    ["Frontend Guild"]
        talksTo: [
            {
                target: "Clara"
                weight: 0.4
                channel: "UX Workshop"
            }
        ]
    }
    Ismael:   types.#Member & {
        name:           "Ismaël"
        role:           "Developer"
        skills:         ["Backend", "API", "CI/CD"]
        seniority:      3
        workload:       1.0
        manager:        null
        contract:       "CDI"
        available:      true
        tenureMonths:   42
        location:       "Paris"
        language:       ["FR"]
        active:         true
        team:           "Team Delta"
        communities:    ["DevOps"]
        pairedWith: [
            {
                target: "Laure"
                context: "Code Review"
            }
        ]
        askAdviceFrom: [
            {
                target: "Samy"
                context: "API Design"
            }
        ]
    },
    Laure:   types.#Member & {
        name:           "Laure"
        role:           "Developer"
        skills:         ["Backend", "API"]
        seniority:      2
        workload:       0.9
        manager:        null
        contract:       "CDI"
        available:      true
        tenureMonths:   18
        location:       "Remote"
        language:       ["FR"]
        active:         true
        team:           "Team Delta"
        pairedWith: [
            {
                target: "Ismaël"
                context: "Code Review"
            }
        ]
        blockedBy: [
            {
                target: "Samy"
                context: "Missing Specs"
            }
        ]
    },
    Samy:   types.#Member & {
        name:           "Samy"
        role:           "API Architect"
        skills:         ["Architecture", "Documentation"]
        seniority:      3
        workload:       1.0
        manager:        null
        contract:       "Freelance"
        available:      true
        tenureMonths:   12
        location:       "Paris"
        language:       ["FR", "EN"]
        active:         true
        team:           "Team Delta"
        mentors: [
            {
                target: "Laure"
                context: "Architecture"
            }
        ]
    }
    Malika:   types.#Member & {
        name:           "Malika"
        role:           "Developer"
        skills:         ["Backend", "Exploration"]
        seniority:      3
        workload:       1.0
        manager:        null
        contract:       "CDI"
        available:      true
        tenureMonths:   48
        location:       "Paris"
        language:       ["FR", "EN"]
        active:         true
        team:           "Team Gamma"
        mentors: [
            {
                target: "Yassine"
                context: "Onboarding"
            }
        ]
        pairedWith: [
            {
                target: "Nora"
                context: "POC Back/Front"
            }
        ]
    },   
    Nora:   types.#Member & {
        name:           "Nora"
        role:           "Fullstack Developer"
        skills:         ["Tooling", "Interconnexion"]
        seniority:      2
        workload:       1.0
        manager:        null
        contract:       "CDI"
        available:      true
        tenureMonths:   12
        location:       "Remote"
        language:       ["EN"]
        active:         true
        team:           "Team Gamma"
        communities:    ["Frontend Guild"]
        pairedWith: [
            {
                target: "Malika"
                context: "POC Back/Front"
            }
        ]
        blockedBy: [
            {
                target: "Pierre"
                context: "Manque de priorisation"
            }
        ]
    },   
    Pierre:   types.#Member & {
        name:           "Pierre"
        role:           "Agile Coach"
        skills:         ["Coaching", "Facilitation"]
        seniority:      3
        workload:       0.5
        manager:        null
        contract:       "Freelance"
        available:      true
        tenureMonths:   6
        location:       "Paris"
        language:       ["FR"]
        active:         true
        team:           "Team Gamma"
        communities:    ["Agile Practitioners"]
        askAdviceFrom: [
            {
                target: "Malika"
                context: "Culture technique"
            }
        ]
    },
    Yacine:   types.#Member & {
        name:           "Yassine"
        role:           "Developer"
        skills:         ["Frontend"]
        seniority:      1
        workload:       0.8
        manager:        null
        contract:       "ESN"
        available:      true
        tenureMonths:   2
        location:       "Remote"
        language:       ["FR"]
        active:         true
        team:           "Team Gamma"
        communities:    ["Frontend Guild"]
        askAdviceFrom: [
            {
                target: "Malika"
                context: "Projet de migration"
            }
        ]
    }  
    Antoine:   types.#Member & {
        name:           "Antoine"
        role:           "Test Engineer"
        skills:         ["QA", "Tests d'intégration"]
        seniority:      2
        workload:       1.0
        manager:        null
        contract:       "CDI"
        available:      true
        tenureMonths:   24
        location:       "Paris"
        language:       ["FR"]
        active:         true
        team:           "Team Omega"
        talksTo: [
            {
                target: "Lina"
                context: "Revue de specs"
            }
        ]
    },
    Lina:   types.#Member & {
        name:           "Lina"
        role:           "Integration Developer"
        skills:         ["Backend", "Tests automatisés"]
        seniority:      2
        workload:       1.0
        manager:        null
        contract:       "ESN"
        available:      true
        tenureMonths:   18
        location:       "Remote"
        language:       ["FR", "EN"]
        active:         true
        team:           "Team Omega"
        communities:    ["DevOps"]
        pairedWith: [
            {
                target: "Kevin"
                context: "CI tests"
            }
        ]
    },
    Kevin:   types.#Member & {
        name:           "Kevin"
        role:           "Integration Developer"
        skills:         ["CI/CD", "Scripts"]
        seniority:      2
        workload:       1.0
        manager:        null
        contract:       "CDI"
        available:      true
        tenureMonths:   20
        location:       "Paris"
        language:       ["FR"]
        active:         true
        team:           "Team Omega"
        communities:    ["DevOps"]
        pairedWith: [
            {
                target: "Lina"
                context: "CI tests"
            }
        ]
        blockedBy: [
            {
                target: "Antoine"
                context: "Tests KO sur pipeline"
            }
        ]
    },
    Nassim:   types.#Member & {
        name:           "Nassim"
        role:           "DevOps"
        skills:         ["CI/CD", "Automation"]
        seniority:      3
        workload:       1.0
        manager:        null
        contract:       "CDI"
        available:      true
        tenureMonths:   36
        location:       "Paris"
        language:       ["FR"]
        active:         true
        team:           "Team Sigma"
        communities:    ["DevOps"]
        pairedWith: [
            {
                target: "Sonia"
                context: "CI/CD Pipelines"
            }
        ]
    },
    Sonia:   types.#Member & {
        name:           "Sonia"
        role:           "SRE"
        skills:         ["Observabilité", "Monitoring"]
        seniority:      3
        workload:       1.0
        manager:        null
        contract:       "CDI"
        available:      true
        tenureMonths:   30
        location:       "Remote"
        language:       ["FR", "EN"]
        active:         true
        team:           "Team Sigma"
        communities:    ["DevOps"]
        pairedWith: [
            {
                target: "Nassim"
                context: "CI/CD Pipelines"
            }
        ]
        askAdviceFrom: [
            {
                target: "Anna"
                context: "Grafana Dashboards"
            }
        ]
        mentors: [
            {
                target: "Anna"
                context: "Monitoring onboarding"
            }
        ]
    },
    Thierry:   types.#Member & {
        name:           "Thierry"
        role:           "Platform PO"
        skills:         ["Platform Management", "Documentation"]
        seniority:      3
        workload:       1.0
        manager:        null
        contract:       "CDI"
        available:      true
        tenureMonths:   24
        location:       "Paris"
        language:       ["FR"]
        active:         true
        team:           "Team Sigma"
        communities:    ["Agile Practitioners"]
        blockedBy: [
            {
                target: "Nassim"
                context: "Release bloquée"
            }
        ]
    },
    Leo:   types.#Member & {
        name:           "Léo"
        role:           "Security Engineer"
        skills:         ["Security", "Vulnerability Scanning"]
        seniority:      2
        workload:       1.0
        manager:        null
        contract:       "ESN"
        available:      true
        tenureMonths:   12
        location:       "Remote"
        language:       ["FR"]
        active:         true
        team:           "Team Sigma"
        communities:    ["DevOps"]
        talksTo: [
            {
                target: "Anna"
                context: "Hardening"
            }
        ]
        mentors: [
            {
                target: "Sonia"
                context: "Incident response"
            }
        ]
    },
    Anna:   types.#Member & {
        name:           "Anna"
        role:           "Tooling Developer"
        skills:         ["Tooling", "Monitoring"]
        seniority:      2
        workload:       1.0
        manager:        null
        contract:       "CDI"
        available:      true
        tenureMonths:   18
        location:       "Paris"
        language:       ["EN"]
        active:         true
        team:           "Team Sigma"
        communities:    ["DevOps"]
        talksTo: [
            {
                target: "Léo"
                context: "Security tooling"
            }
        ]
    }
}
