package artifacts

import "github.com/winael/cue-agent-sna/cue/types"

artifacts: [name=string]: types.#Artifact // New section for all artifacts
artifacts: {
    UserService: types.#Artifact & {name: "UserService", type: "service", dependsOn: []}
    OrderService: types.#Artifact & {name: "OrderService", type: "service", dependsOn: ["UserService"]}
    PaymentService: types.#Artifact & {name: "PaymentService", type: "service", dependsOn: ["UserService"]}
    WebApp: types.#Artifact & {name: "WebApp", type: "application", dependsOn: ["OrderService", "PaymentService"]}
    SharedLibrary: types.#Artifact & {name: "SharedLibrary", type: "library", dependsOn: []}
}
