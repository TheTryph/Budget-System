local object = require("@libraries/classic")
local Account = require("../Classes/Account")
local TransactionController = require("../Controllers/TransactionController")

local Ledger = object:extend()

function Ledger:new()
    self.Accounts = {}
    self.Transactions = {}

end

function Ledger:createAccount(name : string)
    local Account = Account(name)
    table.insert(self.Accounts, Account)
    return Account
end

function Ledger:AddMoney(account, amount)
    account.Wallet:AddMoney(amount)
end

function Ledger:Transfer(transactionName, from, to, amount)
    if typeof(from) == "string" then
        from = self:GetAccountByName(from)
    end
    if typeof(to) == "string" then
        to = self:GetAccountByName(to)
    end
    local Transaction = TransactionController:Move(transactionName, from, to, amount)
    table.insert(self.Transactions, Transaction)
end

function Ledger:GetAccounts()
    return self.Accounts
end

function Ledger:ListTransactions()
    for _,v in pairs(self.Transactions) do
        print(v)
    end
end
function Ledger:ListAccounts()
    local list = {}
    for _, acc in pairs(self.Accounts) do
        local serializedAccount = {Name = acc.Name, Amount = acc.Wallet:GetAmount()}
        print(acc)
        table.insert(list, serializedAccount)
    end
    return list
end

function Ledger:GetAccountByName(name : string)
    for _, acc in pairs(self.Accounts) do
        if acc.Name == name then
            return acc
        end
    end
    return nil
end

return Ledger
