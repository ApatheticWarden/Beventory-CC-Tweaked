if(arg[1] == nil or arg[2] == nil) then
    print("Not enough argumets")
    print("Usage: ", arg[0], "<Input storage count><Ouput storage name>")
    return
end

term.setTextColor(colors.red)
print("!WARNING! \nMAKE SURE TO ACCUIRE OUTPUT CORRECTLY")
term.setTextColor(colors.orange)
print("Attention!")
print(arg[2], "was set as output")
print(tonumber(arg[1]), " storage units (s.u.) will be initialized")
term.setTextColor(colors.white)
local target = peripheral.wrap(arg[2])
-- peripheral.find("minecraft:chest")
local alli = {}
local allPeripherals = peripheral.getNames()
local s1 = peripheral.find("speaker")
local alls = {s1}

local n = tonumber(arg[1])
local count = 0

for i, name in ipairs(allPeripherals) do
    if peripheral.getType(name) == "minecraft:chest" then
        count = count + 1
        alli[count] = peripheral.wrap(name)
        if count >= n then break end
    end
end

function makeSound(speaker, sound)
    for i,sp in ipairs(speaker) do
        sp.playSound(sound)
    end
end

function readItems(inventory)
    if inventory.list() ~= nil then
        for i,item in pairs(inventory.list()) do
            print(item.name, " - ", item.count)
        end
    end
end

function findItems(inventory, target, targetItem)
    local sum = 0
    for i, item in pairs(inventory.list()) do
        if string.find(item.name,targetItem,1,true) then
            inventory.pushItems(peripheral.getName(target), i)
            sum = sum + 1
        end
    end
    if sum <= 0 then
        makeSound(alls, "minecraft:entity.villager.no")
        term.setTextColor(colors.red)
        print(targetItem, " was not found in ", peripheral.getName(inventory))
    else
        makeSound(alls, "minecraft:entity.villager.yes")
        term.setTextColor(colors.green)
        print("Success")    
    end
    term.setTextColor(colors.white)
end

function clearScreen(n)
    local i = 0
    while i < n do
        print("Cleaning screen in ", n-i ,"...")
        i = i + 1
        sleep(1)
    end
    term.clear()
end

function parseArg(input)
    if input then
        local command, arg = input:match("^(%S+)%s*(.*)$")
        return command, arg 
    end
end

local exit = false

while exit ~= true do
    print("Beventory 1.0!\n What do you want to find?\n<Find> - find item | <Read> - read storage \n<Exit> - to stop programm")
    local pos = term.getCursorPos()
    local choise = read()
    local command, arg = parseArg(choise)
    if command == nil then
        print("Not an command")
        sleep(2)
    elseif string.find(string.lower(command),"exit",1,true) then
        exit = true
    elseif string.find(string.lower(command),"find",1,true) then
        if arg == nil or arg == "" then
            print("Must be an argument after <find>!")
            sleep(2)
        else
            print("Find: ")
            print("Seeking for ", arg, "..")
            for i, chest in ipairs(alli) do
                findItems(chest,target,arg)
            end
            clearScreen(3)
        end
    elseif string.find(string.lower(command),"read",1,true) then
        for i,chest in pairs(alli) do
            readItems(chest)
        end
        clearScreen(5)
    else
        print("Wrong command")
        sleep(1)
    end
    term.clear()
    term.setCursorPos(1,1)             
end

print("Bye!")
