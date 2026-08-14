local stdio = require("@lune/stdio")

local build_info = require("./build_info")
local binary_directory = require("./utils/binary_directory")
local months = require("./constants/months")
--[[
data = {
    dailyAllowance = 50,
    initialSavings = 20,
    datasetBeginTime = 1785711600,
    days = {
        {
            midnightTime = 1785711600,
            transactions = {
                {
                    name = "Dinner",
                    amount = 20,
                    timestamp = 1785716632
                }
            }
        },
        {
            midnightTime = 1785343600,
            transactions = {
                {
                    name = "Dinner",
                    amount = 20,
                    timestamp = 1785373600
                }
            }
        }
    }
}
]]
local data = binary_directory.loadPermanentData()
local function getTodayDay()
    local currentDate = os.date("*t")

    -- 2. Construct a dictionary representing exactly 00:00:00 of today
    local midnightTable = {
        year  = currentDate.year,
        month = currentDate.month,
        day   = currentDate.day,
        hour  = 0,
        min   = 0,
        sec   = 0
    }

    -- 3. Convert the dictionary into a Unix timestamp
    local localMidnightTimestamp = os.time(midnightTable)
    return localMidnightTimestamp
end
local function calculateSavings()
    local saved = data.initialSavings or 0
    for _,v in pairs(data.days) do
        local allowance = v.allowance
        for _, transaction in v.transactions do
            allowance -= transaction.amount
        end
        saved +=allowance
    end

    for _,v in pairs(data.savingsTransactions) do
        saved -= v.amount
    end

    print(saved)
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

local function inputTransaction(name, amount)
    local todayTableIndex = checkTodayTable()
    local transaction = {
        name = name,
        amount = amount,
        timestamp = os.time()
    }
    table.insert(data.days[todayTableIndex].transactions, transaction)
    binary_directory.savePermanentData(data)
end

local function inputSavingsTransaction(name, amount)
    local transaction = {
         name = name,
        amount = amount,
        timestamp = os.time()
    }
    table.insert(data.savingsTransactions, transaction)
    binary_directory.savePermanentData(data)
end

local function getDayStats(day)
    local amountSpent = 0
    local amountSaved = day.allowance
    for _, transaction in day.transactions do
        amountSpent += transaction.amount
    end
    amountSaved -= amountSpent
    return amountSpent, amountSaved
end

local function showAllTransactions()
    local beginDate = os.date("*t", data.datasetBeginTime)
    print(string.format("Beginning of dataset: %s %s, %s at %s", months[beginDate.month], beginDate.day, beginDate.year, os.date("%H:%M:%S", data.datasetBeginTime)))
    for _, day in data.days do
        local amountSpent, amountSaved = getDayStats(day)
        local date = os.date("*t", day.midnightTime)
        print(string.format("%s %s, %s", months[date.month], date.day, date.year))
        for transactionIndex, transaction in day.transactions do
            print(string.format("   %s %s %sMAD", os.date("%H:%M:%S", transaction.timestamp), transaction.name, -transaction.amount))
        end
        print(string.format("Result: %sMAD spent, %sMAD saved", amountSpent, amountSaved))
    end
end

local function showAllSavingsTransactions()
    local beginDate = os.date("*t", data.datasetBeginTime)
    print(string.format("Beginning of dataset: %s %s, %s at %s", months[beginDate.month], beginDate.day, beginDate.year, os.date("%H:%M:%S", data.datasetBeginTime)))
    for _,transaction in data.savingsTransactions do
        local date = os.date("*t", transaction.timestamp)
        print(string.format("%s:\n %s %s, %s at %s: %s MAD", transaction.name, months[date.month], date.day, date.year, os.date("%H:%M:%S", transaction.timestamp), -transaction.amount))
    end
end

local buildDate = os.date("*t", build_info.date)
local features = {
    {
        Name = "Log a transaction",
        Callback = function()
            stdio.write("")
            local name = stdio.prompt("text", "Insert the name of the transaction");
            local amount = stdio.prompt("text", "Insert the amount deducted");
            inputTransaction(name, tonumber(amount));
        end
    },
    {
        Name = "Log a savings transaction",
        Callback = function()
            stdio.write("")
            local name = stdio.prompt("text", "Insert the name of the transaction");
            local amount = stdio.prompt("text", "Insert the amount deducted");
            inputSavingsTransaction(name, tonumber(amount));
        end
    },
    {
        Name = "Show savings",
        Callback = function()
            calculateSavings()
        end
    },
    {
        Name = "List all day-to-day transactions",
        Callback = function()
            showAllTransactions()
        end
    },
    {
        Name = "List all savings transactions",
        Callback = function()
            showAllSavingsTransactions()
        end
    },
    {
        Name = "Show build info",
        Callback = function()
            print(string.format("Build date: %s %s, %s T %s", months[buildDate.month], buildDate.day, buildDate.year, os.date("%H:%M:%S", build_info.date)))
            print(string.format("Version: %s", build_info.version))
        end
    },
    {
        Name = "Exit",
        Callback = function()
            return "EXIT_EVENT"
        end
    }
}

local loop = true
stdio.write(string.format("Welcome to the financial tracking utility! (%s %s, %s T %s build)\n", months[buildDate.month], buildDate.day, buildDate.year, os.date("%H:%M:%S", build_info.date)))
--stdio.write(string.format("You have %s left for today!"))
while loop do
    stdio.write("What would you like to do?\n")
    local bakedFeatures = {}
    for i,v in features do
       table.insert(bakedFeatures, string.format("%s. %s", i, v.Name))
    end
    local featureSelect = stdio.prompt("select", "Select the feature you want", bakedFeatures)
    
    if featureSelect then
        local EVENT = features[featureSelect].Callback()
        if EVENT == "EXIT_EVENT" then
            loop = false
        end
    end
end