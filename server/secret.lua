local serverSecret = nil
local characterPool = {}

-- Build character pool: digits (0-9) and lowercase letters (a-z)
for i = 48, 57 do -- ASCII 48-57 = '0'-'9'
    table.insert(characterPool, string.char(i))
end

for i = 97, 122 do -- ASCII 97-122 = 'a'-'z'
    table.insert(characterPool, string.char(i))
end

function GenerateRandomString(length)
    if not length or length <= 0 then
        return ""
    end
    
    local result = GenerateRandomString(length - 1)
    local randomIndex = math.random(1, #characterPool)
    local randomChar = characterPool[randomIndex]
    
    return result .. randomChar
end

function InitializeServerSecret()
    -- Seed random number generator with current time
    local timeString = tostring(os.time())
    local reversedTime = string.reverse(timeString)
    local seedValue = tonumber(string.sub(reversedTime, 1, 6))
    math.randomseed(seedValue)
    
    -- Generate some random numbers to "warm up" the RNG
    for i = 0, 50 do
        math.random(0, 1000)
    end
    
    -- Try to load existing API key
    local resourceName = GetCurrentResourceName()
    local existingKey = LoadResourceFile(resourceName, ".rcore_api_key")
    
    if existingKey == nil then
        -- Generate new 64-character API key
        serverSecret = GenerateRandomString(64)
        SaveResourceFile(resourceName, ".rcore_api_key", serverSecret)
    else
        serverSecret = existingKey
    end
end

function GetServerSecret()
    return serverSecret
end

-- Initialize the server secret when the resource starts
Citizen.CreateThread(InitializeServerSecret)