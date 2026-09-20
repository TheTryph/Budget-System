local stdio = require("@lune/stdio")

local build_info = require("./build_info")
local timestamp_converter = require("./utils/timestamp_converter")
local data_manager = require("./data_manager")

local features = {
    {
        Name = "Log a transaction",
        Callback = function()
            stdio.write("")
            local name = stdio.prompt("text", "Insert the name of the transaction");
            local amount = stdio.prompt("text", "Insert the amount change");
            data_manager:inputTransaction(name, tonumber(amount));
        end
    },
    {
        Name = "Log a savings transaction",
        Callback = function()
            stdio.write("")
            local name = stdio.prompt("text", "Insert the name of the transaction");
            local amount = stdio.prompt("text", "Insert the amount change");
            data_manager:inputSavingsTransaction(name, tonumber(amount));
        end
    },
    {
        Name = "Show savings",
        Callback = function()
            print(data_manager:calculateSavings())
        end
    },
    {
        Name = "List all day-to-day transactions",
        Callback = function()
            data_manager:showAllTransactions()
        end
    },
    {
        Name = "List all savings transactions",
        Callback = function()
            data_manager:showAllSavingsTransactions()
        end
    },
    {
        Name = "Show build info",
        Callback = function()
            print(string.format("Build date: %s", timestamp_converter:getFullDate(build_info.date)))
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
stdio.write(string.format("Welcome to the financial tracking utility! (%s build)\n", timestamp_converter:getFullDate(build_info.date)))
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