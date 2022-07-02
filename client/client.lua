--[[
    Author: AussieDropBears
    Description: ShotSpotter for FiveM
]]

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerPed = GetPlayerPed(-1)
        local isShooting = IsPedShooting(playerPed)
        local isCop = exports.AspireRP:isPersonCop()

        --  If a Police Officer is shooting it will trigger a Priority in progress.
        -- If Config.EnablePriority - if this is set to true in config.lua otherwise it will just trigger the shotspotter event

        if Config.EnablePriority == true then
        if isCop and isShooting then
            ExecuteCommand("priority")
            --print("does the cop one work?e")
            TriggerEvent("ShotSpotterEvent")
            Wait(60 * 1000 * 5) -- You might want to wait 1 or 2 minutes to avoid spamming the event - i have this set to 5 minutes incase of a shootout
        elseif Config.EnablePriority == false and isCop and isShooting then
            TriggerEvent("ShotSpotterEvent")
            Wait(60 * 1000 * 5)
        end

        -- If a Civilian Shoots it will alert the authoritys. and Display a Blip of the area if it's enabled in Config.lua :D

        if isShooting and Config.EnableBlips == true then
           -- print("Civilian is Shooting w/ Blips Enabled")
            TriggerEvent("ShotSpotterEvent")
            TriggerEvent("ShotSpotterEventBlips")
            Wait(60 * 1000 * 5)
        elseif isShooting and Config.EnableBlips == false then
            TriggerEvent("ShotSpotterEvent")
            Wait(60 * 1000 * 5)
        end

end
end
end)

RegisterNetEvent("ShotSpotterEvent")
AddEventHandler("ShotSpotterEvent", function(source)
    exports.AspireRP:SendShotSpotter() -- This sends the notification to on-duty LEO using exports to another resource -BTTarget
end)


RegisterNetEvent("ShotSpotterEventBlips")
AddEventHandler("ShotSpotterEventBlips", function(source)



end)
