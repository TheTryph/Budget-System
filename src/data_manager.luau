local module = {}
local binary_directory = require("./utils/binary_directory")
local getTodayDay = require("./utils/getTodayDay")
local timestamp_converter = require("./utils/timestamp_converter")


local data = binary_directory.loadPermanentData()


function module:calculateSavings()
    local saved = data.initialSavings or 0
    for _,v in pairs(data.days) do
        local allowance = v.allowance
        for _, transaction in v.transactions do
            allowance += transaction.amount
        end
        saved += allowance
    end

    for _,v in pairs(data.savingsTransactions) do
        saved -= v.amount
    end

    return saved
end

local function checkTodayTable()
    local todayMidnightTime = getTodayDay();
    
    for index,day in pairs(data.days) do
        if day.midnightTime == todayMidnightTime then
            return index
        end
    end
    local dayTable = {
        midnightTime = getTodayDay(),
        allowance = data.dailyAllowance,
        transactions = {}
    }
    data.days[#data.days+1]=dayTable
    return #data.days
end



function module:inputTransaction(name, amount)
    local todayTableIndex = checkTodayTable()
    local transaction = {
        name = name,
        amount = amount,
        timestamp = os.time()
    }
    table.insert(data.days[todayTableIndex].transactions, transaction)
    binary_directory.savePermanentData(data)
end

function module:inputSavingsTransaction(name, amount)
    local transaction = {
         name = name,
        amount = amount,
        timestamp = os.time()
    }
    table.insert(data.savingsTransactions, transaction)
    binary_directory.savePermanentData(data)
end

function module:getDayStats(day)
    local amountChange = 0
    local amountSaved = day.allowance
    for _, transaction in day.transactions do
        amountChange += transaction.amount
    end
    amountSaved += amountChange
    return amountChange, amountSaved
end


function module:showAllTransactions()
    print(string.format("Beginning of dataset: %s", timestamp_converter:getFullDate(data.datasetBeginTime)))
    for _, day in data.days do
        local amountChange, amountSaved = module:getDayStats(day)
        print(string.format("%s", timestamp_converter:getDate(day.midnightTime)))
        for transactionIndex, transaction in day.transactions do
            print(string.format("   %s %s %sMAD", timestamp_converter:getClock(transaction.timestamp), transaction.name, transaction.amount))
        end
        print(string.format("Result: %sMAD variation, %sMAD saved", amountChange, amountSaved))
    end
end

function module:showAllSavingsTransactions()
    print(string.format("Beginning of dataset: %s", timestamp_converter:getFullDate(data.datasetBeginTime)))
    for _,transaction in data.savingsTransactions do
        print(string.format("%s:\n %s: %s MAD", transaction.name, timestamp_converter:getFullDate(transaction.timestamp), transaction.amount))
    end
end


return module