local function readWithTimeout(timeout, default)
    --term.write("> ")
    local input = ""
    local timer = os.startTimer(timeout)

    while true do
        local event, p1 = os.pullEvent()

        if event == "char" then
            input = input .. p1
            term.write(p1)
        elseif event == "key" and p1 == keys.backspace then
            input = string.sub(input, 1, -2)
        elseif event == "key" and p1 == keys.enter then
            print()
            return input -- User pressed Enter
        elseif event == "timer" and p1 == timer then
            print("\n[Timeout]")
            return default -- Timeout occurred
        end
    end
end

local branch = settings.get("branch.setting", "main")


if not fs.exists("client.lua") and not fs.exists("startup.lua") then
    write("\nEnter current branch\n > ")
    local branch = readWithTimeout(10, "main")
    settings.define("branch.setting", {
        description = "Which branch CC-Storage is using",
        default = "main",
        type = "string"
    })
    settings.set("branch.setting", branch)

    write("\n\nREQUIRED FOR SYNC:\nThis device is ID "..os.computerID().."\n\nEnter home/server ID\n > ")
    local serverID = read()
    
    shell.run("wget https://raw.githubusercontent.com/DeactivatedMan/CC-Stasis/refs/heads/"..branch.."/Client/client.lua")

    local file = fs.open("client.lua", "r")
    local lines = {}

    local line = file.readLine()
    while line do
        table.insert(lines, line)
        line = file.readLine()
    end
    file.close()
    lines[1] = "local id = "..serverID

    file = fs.open("client.lua", "w")
    for _,l in ipairs(lines) do
        file.writeLine(l)
    end
    file.close()
    shell.run("rename client.lua startup.lua")
    shell.run("reboot")
end