local module = {}
local months = require("../constants/months")

function module:getDate(timestamp)
    local convertedTimestamp = os.date("*t", timestamp)
    return string.format("%s %s, %s", months[convertedTimestamp.month], convertedTimestamp.day, convertedTimestamp.year)
end

function module:getClock(timestamp)
    local convertedTimestamp = os.date("%H:%M:%S", timestamp)
    return convertedTimestamp
end

function module:getFullDate(timestamp)
    local Date = module:getDate(timestamp)
    local Clock = module:getClock(timestamp)
    return string.format("%s T %s", Date, Clock)
end


return module
