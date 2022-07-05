--[[
    Author: Joaquin_Guzman
    Description: ShotSpotter for FiveM
    Notes: Made for discord.gg/doj
]]

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerPed = GetPlayerPed(-1)
        local isShooting = IsPedShooting(playerPed)
        local isCop = exports.AspireRPV2:isPersonCop()
        local ped = GetPlayerPed(-1)
        local plyPos = GetEntityCoords(ped,  true)

        --  If a Police Officer is shooting it will trigger a Priority in progress.
        -- If Config.EnablePriority - if this is set to true in config.lua otherwise it will just trigger the shotspotter event

        if Config.EnablePriority == true then
        if isCop and isShooting then
            ExecuteCommand("priority")
            TriggerServerEvent("SendShotSpotterToTheCad")
           TriggerEvent("ShotSpotterEventBlips", -1, plyPos.x, plyPos.y, plyPos.z)
          TriggerEvent("PoliceShotSpotterNotification")
            Wait(60 * 1000 * 5) -- You might want to wait 1 or 2 minutes to avoid spamming the event - i have this set to 5 minutes incase of a shootout
        elseif Config.EnablePriority == false and isCop and isShooting then
           TriggerEvent("PoliceShotSpotterNotification")
           TriggerEvent("ShotSpotterEventBlips", -1, plyPos.x, plyPos.y, plyPos.z)
            Wait(60 * 1000 * 5)
        end

        -- If a Civilian Shoots it will alert the authoritys. and Display a Blip of the area if it's enabled in Config.lua :D

        if isShooting and Config.EnableBlips == true then
           TriggerEvent("PoliceShotSpotterNotification")
           TriggerEvent("ShotSpotterEventBlips", -1, plyPos.x, plyPos.y, plyPos.z)
            Wait(60 * 1000 * 5)
        elseif isShooting and Config.EnableBlips == false then
          TriggerEvent("PoliceShotSpotterNotification")
            Wait(60 * 1000 * 5)
        end

end
end
end)

local blipActive = false

RegisterNetEvent("ShotSpotterEventBlips")
AddEventHandler("ShotSpotterEventBlips", function(source, x, y, z)
  local isCop = exports.AspireRPV2:isPersonCop()
  local veh = GetLastDrivenVehicle(ped)
  local plate = GetVehicleNumberPlateText(veh)
  local ped = GetPlayerPed(-1)
  local plyPos = GetEntityCoords(ped,  true)

      -- if isCop then
        local gunshotBlip = AddBlipForRadius(plyPos.x, plyPos.y, plyPos.z, 1000.0)
        SetBlipSprite(gunshotBlip, 161)
        SetBlipColour(gunshotBlip, 1)
        SetBlipAsShortRange(gunshotBlip, 0)
        Citizen.Wait(60000)
        SetBlipSprite(gunshotBlip, 2)
 -- end

end)

-- CarJacking Notification
RegisterNetEvent("PoliceCarJackingNotification")
AddEventHandler("PoliceCarJackingNotification", function(source)
    local veh = GetLastDrivenVehicle(ped)
    local ped = GetPlayerPed(-1)
    local plate = GetVehicleNumberPlateText(veh)
    local pos = GetEntityCoords(PlayerPedId())
    local var1 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local Location = GetStreetNameFromHashKey(var1)
    local isCop = exports.AspireRPV2:isPersonCop()

        if isCop then
            TriggerEvent('chat:addMessage', {color = { 255, 0, 0} ,multiline = true, args = {"Goverment", "^1Car-Jacking in Progress^0 Location: " .. Location .. " Plate: " .. plate .. ""}})
   end

end)
-- ShotSpotter Notification
RegisterNetEvent("PoliceShotSpotterNotification")
AddEventHandler("PoliceShotSpotterNotification", function(source)
    local veh = GetLastDrivenVehicle(ped)
    local plate = GetVehicleNumberPlateText(veh)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(PlayerPedId())
    local var1 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local Location = GetStreetNameFromHashKey(var1)
    local isCop = exports.AspireRPV2:isPersonCop()

        if isCop then
            Notify("~b~[DISPATCH]~w~ Gunshots detected near " .. Location)
   end

end)

function Notify(Text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(Text)
    DrawNotification(true, true)
end
