local TransactionController = {}
local Transaction = require("../Classes/Transaction")
function TransactionController:Move(name, from, to, amount, currency : string?)
    local newTransaction = Transaction(name, from, to, amount, currency)
    table.insert(from.Transactions, newTransaction)
    table.insert(to.Transactions, newTransaction)
    from.Wallet:RemoveMoney(amount, currency)
    to.Wallet:AddMoney(amount, currency)
    return newTransaction
end

return TransactionController