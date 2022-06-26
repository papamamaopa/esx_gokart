local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169,
	["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162,
	["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199,
	["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82,
	["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61,
	["N9"] = 118
}

ESX              = nil
local PlayerData = {}
local ui         = false
local modelHash
local time
local isDriving
local noMoneyError
local esxVehicle

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

-- block any user move
CreateThread(function()
	while true do
		local sleep = 1500

		if ui then
			sleep = 0
			DisableControlAction(0, 1, true) -- LookLeftRight
			DisableControlAction(0, 2, true) -- LookUpDown
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30, true) -- MoveLeftRight
			DisableControlAction(0, 31, true) -- MoveUpDown
			DisableControlAction(0, 21, true) -- disable sprint
			DisableControlAction(0, 24, true) -- disable attack
			DisableControlAction(0, 25, true) -- disable aim
			DisableControlAction(0, 47, true) -- disable weapon
			DisableControlAction(0, 58, true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75, true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle
		end
		Wait(sleep)
	end
end)

RegisterNetEvent("nuigo:on")
AddEventHandler("nuigo:on", function(value)
	print("nui:on -> triggerd")
	SendNUIMessage({ showUI = true })
	ui = true
	SetNuiFocus(true, true)
	TriggerScreenblurFadeIn(20)
end)

RegisterNUICallback("nui:pushKart", function(value)
	print("nui:send -> test")
	SendNUIMessage({ showUI = false })
	ui = false
	SetNuiFocus(false, false)
	TriggerScreenblurFadeOut(20)

	local driveTime = value.time

	if (isDriving) then
		SetNotificationTextEntry("STRING");
		AddTextComponentString("Deine Miete läuft noch!");
		SetNotificationMessage("CHAR_LAZLOW2", "CHAR_LAZLOW2", true, 1, "~w~Kartstrecken CEO~w~",
			"Du hast bereits ein Kart gemietet!~w~", "");
		DrawNotification(false, true);
		return
	end


	if (value.kart == 0) then
		modelHash = "kart26"
	end
	if (value.kart == 1) then
		modelHash = "kart20"
	end
	if (value.kart == 2) then
		modelHash = "kart3"
	end

	local playerPed = PlayerPedId()
	ESX.Game.SpawnVehicle(modelHash, vector3(-1649.85, -825.21, 9.40), 52.59, function(vehicle)
		TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
		isDriving = true
		esxVehicle = vehicle
	end)



	while (driveTime ~= 0) do
		Wait(1000)
		driveTime = driveTime - 1
		if (driveTime == 0) then
			ESX.Game.DeleteVehicle(esxVehicle)
			isDriving = false
		end
		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), -1644.8, -970.86, 7.55, true) > 160.0 then
			if not (driveTime <= 3) then
				driveTime = 3
			end
		end
		print(driveTime)
	end
end)

RegisterNUICallback("nui:off", function(value, cb)
	print("nui:off -> triggerd")
	SendNUIMessage({ showUI = false })
	ui = false
	SetNuiFocus(false, false)
	TriggerScreenblurFadeOut(
		10
	)
end)

Citizen.CreateThread(function()
	while true do

		local isInMarker = false
		local playerPed  = PlayerPedId()
		local coords     = GetEntityCoords(playerPed)

		Wait(0)
		DrawMarker(1, -1645.39, -821.46, 9.08, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 200, 55, 50, 100, false, true,
			2,
			false, false, false, false)

		if GetDistanceBetweenCoords(coords, -1645.39, -821.46, 9.08, true) < 1.5 then
			isInMarker = true
			ESX.ShowHelpNotification('Drücke ~INPUT_CONTEXT~ um dir ein GoKart zu mieten!')
		else
			isInMarker = false
		end
		if IsControlJustReleased(0, Keys['E']) and isInMarker == true then
			TriggerEvent("nuigo:on", true)
		end

	end
end)


-- Blip
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(-1645.39, -821.46, 9.08)
	SetBlipSprite(blip, 315)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.9)
	SetBlipColour(blip, 49)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("GoKart")
	EndTextCommandSetBlipName(blip)
end)
