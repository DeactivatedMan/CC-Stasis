local id = 19
local selected = 1
local w,h = term.getSize()

local function writeCentered(str, y, offset)
    local leftChars = math.floor( (w - string.len(str) ) / 2)
    term.setCursorPos(leftChars+offset, y)
    term.write(str)
end

local function showDisplay()
    term.clear()

    term.setTextColour(colours.red)
    term.setCursorPos(1,1)
    term.write(string.rep("\127", w))
    term.setCursorPos(1,h)
    term.write(string.rep("\127", w))

    local line = math.floor(h/2)
    term.setTextColour(colours.white)
    writeCentered("Activate Teleporter?", line, 0)

    if selected == 1 then
        term.setBackgroundColour(colours.green)
        term.setTextColour(colours.black)
        writeCentered("YES", line+1, -5)
        
        term.setBackgroundColour(colours.black)
        term.setTextColour(colours.red)
        writeCentered(" NO", line+1, 5)
    else
        term.setBackgroundColour(colours.black)
        term.setTextColour(colours.green)
        writeCentered("YES", line+1, -5)
        
        term.setBackgroundColour(colours.red)
        term.setTextColour(colours.black)
        writeCentered(" NO", line+1, 5)
    end
    term.setBackgroundColour(colours.black)
end

showDisplay()

while true do
    local event, key, isHeld = os.pullEvent("key")
    if key == keys.enter then
        if selected == 1 then
            rednet.open("back")
            rednet.send(id, "A")
            rednet.close("back")
            shell.run("shutdown")
        else
            shell.run("shutdown")
        end
    else
        selected = (selected==1 and 2 or 1)
        term.setBackgroundColour(colours.black)
        showDisplay()
    end
end