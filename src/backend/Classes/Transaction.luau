local Object = require("@libraries/classic")
local Wallet = require("./Wallet")

local Transaction = Object:extend()
--[[
Account.__metatable.__tostring = function(self)
    return self:toString()
end
]]
function Transaction:new(Name, from, to, amount, currency : string?)
    self.Name = Name
    self.Wallet = Wallet(Name)
    self.From = from
    self.To = to
    self.Timestamp = os.clock()
    self.Wallet:SetMoney(amount, currency)
end

function Transaction:toString(parent : any?, currency : string?)
    local multiplier = 1
    if parent then
        local str = ""
        if parent == self.From then
            multiplier = -1
        end
        str = str .. string.format("%s; %.02f %s", self.Name, self.Wallet:GetAmount(currency) * multiplier, currency or self.Wallet.Currency)
        if multiplier == 1 then
            str = str .. (" received from %s"):format(self.From.Name)
        else
            str = str .. (" sent to %s"):format(self.To.Name)
        end
        return str
    end
    return string.format("Transaction: %s; Amount: %.02f %s", self.Name, self.Wallet:GetAmount(currency) * multiplier, currency or self.Wallet.Currency)
    
end

function Transaction:__tostring()
    return self:toString()
end

return Transaction