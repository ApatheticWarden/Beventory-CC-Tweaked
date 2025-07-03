if arg[1] == nil then
    print("NO ARGUMENTS")
    return
end

local target = peripheral.wrap("minecraft:chest_1")
local i1, i2, i3, i4, i5, i6, i7, i8 = peripheral.find("minecraft:barrel")
local alli = {i1,i2,i3,i4,i5,i6,i7,i8}
local s1, s2 = peripheral.find("speaker")
local alls = {s1,s2}

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
        if item.name == targetItem then
            inventory.pushItems(peripheral.getName(target), i)
            sum = sum + 1
        end
    end
    if sum <= 0 then
        makeSound(alls, "minecraft:entity.villager.no")
        print(targetItem, " was not found in ", peripheral.getName(inventory))
    else
        makeSound(alls, "minecraft:entity.villager.yes")
        print("Success")    
    end
end

--for i, chest in pairs(all) do
--    readItems(chest)    
--end

for i, chest in pairs(alli) do
    findItems(chest, target, arg[1])
end
