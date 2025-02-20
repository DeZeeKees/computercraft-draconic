local repo = "DeZeeKees/computercraft-draconic" -- Replace with your GitHub username and repo name
local branch = "main" -- Change if using a different branch

local files = { -- List of Lua files to fetch
    "draco_reactor_v2.lua",
    "startup.lua",
    "lib/monitor.lua",
    "lib/reactor.lua",
    "lib/settings.lua",
    "lib/terminal.lua"
}

local baseUrl = "https://raw.githubusercontent.com/" .. repo .. "/" .. branch .. "/"

for _, file in ipairs(files) do
    local url = baseUrl .. file
    local response = http.get(
        url,
        {
            ["Cache-Control"] = "no-cache"
        }
    )
    
    if response then
        local content = response.readAll()
        response.close()
        
        local fileHandle = fs.open(file, "w")
        fileHandle.write(content)
        fileHandle.close()
        
        print("Downloaded: " .. file)
    else
        print("Failed to download: " .. file)
    end
end

print("All files processed.")