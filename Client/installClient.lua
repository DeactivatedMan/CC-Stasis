if not fs.exists("client.lua") and not fs.exists("startup.lua") then
    write("\n\nREQUIRED FOR SYNC:\nThis device is ID "..os.computerID().."\n\nEnter home/server ID\n > ")
    local serverID = read()
    -- run download command here
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
end