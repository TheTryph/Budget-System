local Object = require("@libraries/classic")


local Wallet = Object:extend()
function Wallet:new(Name)
    self.Name = Name
    self.Currency = "MAD"
    self.CurrencyRates = {
        USD = 1,
        MAD = 9.45
    }
    self.Amount = 0
end

function Wallet:AddMoney(amount, currency : string?)
    self.Amount += amount / self.CurrencyRates[currency or self.Currency] * self.CurrencyRates[self.Currency]
end
function Wallet:RemoveMoney(amount, currency : string?)
    self.Amount -= amount / self.CurrencyRates[currency or self.Currency] * self.CurrencyRates[self.Currency]
end

function Wallet:SetMoney(amount, currency : string?)
    self.Amount = amount / self.CurrencyRates[currency or self.Currency] * self.CurrencyRates[self.Currency]
end

function Wallet:GetAmount(currency : string?)
    if currency then
        if self.CurrencyRates[currency] then
            return self.Amount * self.CurrencyRates[currency] / self.CurrencyRates[self.Currency]
        end
        warn("Currency specified not found. returning 0")
        return 0
    else
        return self.Amount
    end
end


return Wallet