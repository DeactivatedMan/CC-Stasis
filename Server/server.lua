rednet.open("left")

-- In format of:
--  [deviceID] = {"relayID", "direction"}

--  relayID can be obtained through the peripherals command
--  direction is relative to the way the relay is facing (face same way as it)
--  read documentation (https://tweaked.cc/) for more help

local idRelay = {
    [20] = {"0", "left"}
}

write("Home ID is "..os.computerID())

while true do
    id, msg = rednet.receive()
    if idRelay[id] then
        local data = idRelay[id]
        local relay = peripheral.wrap("redstone_relay_"..data[1])
        relay.setOutput(data[2], true)
        sleep(.1)
        relay.setOutput(data[2], false)
        sleep(.1)
        relay.setOutput(data[2], true)
    end
end