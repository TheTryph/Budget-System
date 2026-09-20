local Object = require("@libraries/classic")
local Wallet = require("./Wallet")

local Account = Object:extend()
--[[
Account.__metatable.__tostring = function(self)
    return self:toString()
end
]]
function Account:new(Name)
    self.Name = Name
    self.Wallet = Wallet(Name)
    self.Transactions = {}
end

function Account:toString(currency : string?, full : boolean?)
    if full then
        local full_str = ""
        full_str = full_str .. string.format("Account: %s; Balance: %.02f %s\n", self.Name, self.Wallet:GetAmount(currency), currency or self.Wallet.Currency)
        full_str = full_str .. "Transactions: \n"
        for _, transaction in self.Transactions do
            full_str = full_str .. transaction:toString(self) .. "\n"
        end
        return full_str
    else
        return string.format("Account: %s; Balance: %.02f %s", self.Name, self.Wallet:GetAmount(currency), currency or self.Wallet.Currency)
    end
end

function Account:__tostring()
    return self:toString()
end

return Account