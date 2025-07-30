if true then --not fs.exists("server.lua") and not fs.exists("startup.lua") then
    write("\n\nREQUIRED FOR SYNC:\nThis home is ID "..os.computerID().."\n\nPlease note that you will have to edit the downloaded file to add other devices\n\n")
    -- run download command here
    shell.run("rename server.lua startup.lua")
end