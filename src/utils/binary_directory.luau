
-- ============================================================================
-- 1. FILE SYSTEM & BINARY DIRECTORY UTILITIES
-- ============================================================================
local fs = require("@lune/fs")
local serde = require("@lune/serde")
local process = require("@lune/process")
local module = {}

local function getBinaryDirectory(): string
    local exePath = "bin.exe"
    
    if process.args and #process.args > 0 then
        exePath = process.args[1] -- Safely extract execution path
    elseif process.env._ then
        exePath = process.env._   -- Fallback for macOS/Linux shells
    end
    
    local binDir = exePath:gsub("[^/\\]+$", "")
    
    if binDir == "" or binDir == "./" or binDir == ".\\" or binDir:match("main%.luau$") then
        return process.cwd .. "/"
    end
    
    if not binDir:match("[/\\\\]$") then
        binDir = binDir .. "/"
    end
    
    return binDir
end

local BIN_DIR = getBinaryDirectory()
local DATA_FILE_PATH = `{BIN_DIR}permanent_data.json`

local defaultData = {
    dailyAllowance = 50,
    datasetBeginTime = os.time(),
    initialSavings = 0,
    savingsTransactions = {},
    days = {} -- Hard ceiling of 10 months planned
}

function module.loadPermanentData()
    if not fs.isFile(DATA_FILE_PATH) then
        return defaultData
    end
    
    local success, fileContents = pcall(fs.readFile, DATA_FILE_PATH)
    if not success then return defaultData end
    
    local parseSuccess, parsedData = pcall(function()
        return serde.decode("json", fileContents)
    end)
    
    return parseSuccess and parsedData or defaultData
end

function module.savePermanentData(data)
    local jsonString = serde.encode("json", data, true) -- Encode with pretty print formatting
    local success, err = pcall(fs.writeFile, DATA_FILE_PATH, jsonString)
    if not success then
        print(`❌ System Error writing data file to disk: {err}`)
    end
end
return module