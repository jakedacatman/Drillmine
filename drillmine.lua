-- Manage args --
local args = { ... }
if #args > 2 then
    print('Usage: drillmine [CurrentY] [use_rednet]')
    return
end
-- Define varables
local x, y, z = gps.locate(5)
local depth2dig = tonumber(args[1]) or y
--bedrock
depth2dig = depth2dig - 5
local debug = false
local use_rednet = false
if tostring(args[1]) == "true" or tostring(args[2]) == "true" then use_rednet = true end
local vals = {
    'minecraft:diamond_ore',
    'minecraft:iron_ore',
    'minecraft:coal_ore',
    'minecraft:gold_ore',
    'minecraft:redstone_ore',
    'minecraft:emerald_ore',
    'quark:biotite_ore'
}
 
-- Print Functions
 
function printDebug(message)
    if debug then
        term.setTextColor(term.isColor() and colors.gray or colors.white)
        print("[DEBUG]: "..message)
        term.setTextColor(colors.white)
        if use_rednet then
            rednet.broadcast('[DEBUG]: '..message)
        end
    end
end
 
 
function printInfo(message)
    term.setTextColor(term.isColor() and colors.blue or colors.white)
    print("[INFO]: "..message)
    if use_rednet then
        rednet.broadcast('[INFO]: '..message)
    end
    term.setTextColor(colors.white)
end
 
function printError(message)
    term.setTextColor(term.isColor() and colors.red or colors.white)
    print("[ERROR]: "..message)
    if use_rednet then
        rednet.broadcast('[ERROR]: '..message)
    end
    term.setTextColor(colors.white)
end
-- End print functions
 
function checkfuel()
    -- Check if we have enough fuel for a run
    if turtle.getFuelLevel() <= (depth2dig * 2) + 3 then
        printError('You need '..tostring(((depth2dig * 2) + 3) - turtle.getFuelLevel())..' More fuel')
        error()
    end
end
local foundLava = false
function process_block()
    local _,block = turtle.inspect()
    if block.name then
      printDebug('checking block '..block.name)
      for i=1,#vals do
         if block.name == vals[i] then
            printInfo('Found '..block.name)
            turtle.dig()
        elseif block.name == 'minecraft:lava' and not foundLava then
            printInfo('Found lava, refueling...')
            turtle.select(16)
            turtle.place()
            turtle.refuel(1)
            printDebug('Fuel level is '..turtle.getFuelLevel())   
            foundLava = true
        end
    end
    end
end
-- Start of program --
-- Going down loop
if use_rednet then
  rednet.open('right')
end
printDebug('depth2dig set to: '..depth2dig)
checkfuel()
printInfo('Going down...')
local actualDepth = 0
for i=1,depth2dig do
    turtle.digDown()
    turtle.down()
    actualDepth = actualDepth + 1
    for i=1,3 do
        -- This should start with a check and end with a check but i'm not sure how do to it
        -- So i've used this ugly method
        process_block()       
        turtle.turnRight()
    end
    -- This is ugly but faster i hope i can find a cleaner way
    process_block()
    foundLava = false
    if i%10 == 0 then
      printInfo('at depth '..i)
    end
end
-- TODO Find a way to avoid having two loops for virtually the same thing
-- Going up loop
printDebug('Moving to next shaft')
for i=1,3 do
  if turtle.detect() then
    turtle.dig()
  end
  turtle.forward()
end
printInfo('Going up')
for i=1,actualDepth do
    turtle.digUp()
    turtle.up()
    process_block()
    for i=1,3 do
        -- This should start with a check and end with a check but i'm not sure how do to it
        -- So i've used this ugly method
        process_block()
        turtle.turnRight()
    end
    -- This is ugly but faster i hope i can find a cleaner way
    process_block()
    foundLava = false
    if i%10 == 0 then
      printInfo('At depth '..i)
    end
--just to be sure
    actualDepth = 0
end
printInfo('Returned to surface!')
--so you can assess the damage
turtle.forward()
