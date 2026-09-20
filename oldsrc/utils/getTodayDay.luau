return function()
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