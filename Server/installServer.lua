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

if not fs.exists("server.lua") and not fs.exists("startup.lua") then
    write("\nEnter current branch\n > ")
    local branch = readWithTimeout(10, "main")
    settings.define("branch.setting", {
        description = "Which branch CC-Storage is using",
        default = "main",
        type = "string"
    })
    settings.set("branch.setting", branch)

    write("\n\nREQUIRED FOR SYNC:\nThis home is ID "..os.computerID().."\n\nPlease note that you will have to edit the downloaded file to add other devices\n\n")
    sleep(5)
    shell.run("wget https://raw.githubusercontent.com/DeactivatedMan/CC-Stasis/refs/heads/"..branch.."/Server/server.lua")

    shell.run("rename server.lua startup.lua")
    os.setComputerLabel("Teleporter Server")
    shell.run("reboot")
end