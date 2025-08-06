import "github.com/winael/cue-agent-sna/cue/data/valuechains"
import "github.com/winael/cue-agent-sna/cue/data/portfolios"
import "github.com/winael/cue-agent-sna/cue/data/trains"
import "github.com/winael/cue-agent-sna/cue/data/members"
import "github.com/winael/cue-agent-sna/cue/data/artifacts"
import "github.com/winael/cue-agent-sna/cue/data/rituals"
import "github.com/winael/cue-agent-sna/cue/data/okrs"
import "github.com/winael/cue-agent-sna/cue/data/teams"

let allValueChains = valuechains.valueChains
let allPortfolios = portfolios.portfolios
let allTrains = trains.trains
let allMembers = members.members
let allArtifacts = artifacts.artifacts
let allRituals = rituals.rituals
let allOkrs = okrs.okrs
let allTeams = teams.teams

myOrg: {
    valueChains: allValueChains
    portfolios: allPortfolios
    trains: allTrains
    members: allMembers
    artifacts: allArtifacts
    rituals: allRituals
    okrs: allOkrs
    teams: allTeams
}

members_directory: [
    for _, memberInfo in myOrg.members {
        {
            name: memberInfo.name
            role: memberInfo.role
            team: memberInfo.team
        }
    }
]