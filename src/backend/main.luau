local LedgerClass = require("./Classes/Ledger")
local net = require("@lute/net")
local json = require("@std/json")
local io = require("@lute/io")

local Ledger = LedgerClass()
local MainAccount = Ledger:createAccount("Main Account")
local Savings = Ledger:createAccount("Savings")

Ledger:AddMoney(MainAccount, 100)

Ledger:Transfer("Savings Input", "Main Account", "Savings", 20)
Ledger:ListTransactions()
Ledger:ListAccounts()

local configuration : net.Configuration = {}
configuration.port = 3000
configuration.hostname = "localhost"
configuration.handler = function(req : net.ReceivedRequest, server : net.Server)
    print(req.path, req.body)
    if req.path == "/" then
        return "<h1>Budget System Backend</h1>\n <h2> Bisclitaoui </h2>"
    end
    if req.path == "/accounts" then
        return json.serialize(Ledger:ListAccounts())
    end
    if req.path == "/transfer" and req.method == "POST" then
    local input = json.deserialize(req.body)
        io.write(input.from)
        Ledger:Transfer("any", input.from, input.to, tonumber(input.amount))
    end
    if req.path == "/create-account" and req.method == "POST" then
    local input = json.deserialize(req.body)
        local acc = Ledger:createAccount(input.Name)
        Ledger:AddMoney(acc, input.Amount)
    end
    return json.serialize({success = true})
end
net.server.serve(configuration)

