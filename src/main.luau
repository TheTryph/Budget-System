local Account = require("./Classes/Account")
local TransactionManager = require("./Controllers/TransactionController")
local MainAccount = Account("Main Account")
local Savings = Account("Savings")
MainAccount.Wallet:AddMoney(200)

TransactionManager:Move("Initial Dispense", MainAccount, Savings, 15, "USD")
print(MainAccount:toString(nil, true))
print(Savings:toString(nil, true))
