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

RegisterNetEvent("nui:on")
AddEventHandler("nui:on", function(value)
	print("nui:on -> triggerd")
	SendNUIMessage({ showUI = true })
	ui = true
	SetNuiFocus(true, true)
end)

RegisterNUICallback("nui:pushKart", function(value, cb)
	print("nui:send -> triggerd")
	SendNUIMessage({ showUI = false })
	ui = false
	SetNuiFocus(false, false)
	TriggerServerEvent("cart:checkMoney", value.kart, value.price)
end)

RegisterNetEvent("cart:spawn")
AddEventHandler("cart:spawn", function(kart, price)
	print(price, kart)
	if (isDriving) then
		SetNotificationTextEntry("STRING");
		AddTextComponentString("Deine Miete läuft noch!");
		SetNotificationMessage("CHAR_LAZLOW2", "CHAR_LAZLOW2", true, 1, "~w~Kartstrecke~w~",
			"Es wurde eine ~g~Werbung geschalten!~w~", "");
		DrawNotification(false, true);
		return
	end


	if (kart == 0) then
		modelHash = "kart26"
	end
	if (kart == 1) then
		modelHash = "kart20"
	end
	if (kart == 2) then
		modelHash = "kart3"
	end

	print("debug#2")

	if (price == 10000) then
		time = 600
	end
	if (price == 24000) then
		time = 1800
	end
	if (price == 40000) then
		time = 3600
	end


	if not (modelHash == nil) then
		if not IsModelInCdimage(modelHash) then return end
	end


	RequestModel(modelHash)

	print(modelHash)

	while not HasModelLoaded(modelHash) do
		Wait(10)
	end

	print("debug#4")

	local playerPed = PlayerPedId()
	local vehicle = CreateVehicle(modelHash, vector3(-1146.11, -2121.44, 14.56), SetModelAsNoLongerNeeded(modelHash))
	TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
	isDriving = true

	print("debug#5")

	while (time ~= 0) do
		Wait(1000)
		time = time - 1
		if (time == 0) then
			DeleteVehicle(vehicle)
			isDriving = false
		end
		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), -1110.0, -2113.11, 13.64, true) > 60.0 then
			if not (time <= 3) then
				time = 3
			end
		end
		print(time)
	end


end)

RegisterNUICallback("nui:off", function(value, cb)
	print("nui:off -> triggerd")
	SendNUIMessage({ showUI = false })
	ui = false
	SetNuiFocus(false, false)
end)

RegisterNetEvent("CarError")
AddEventHandler("CarError", function(inputText)
	SetNotificationTextEntry("STRING");
	AddTextComponentString(inputText);
	SetNotificationMessage("CHAR_LAZLOW2", "CHAR_LAZLOW2", true, 1, "~w~Kartstrecke~w~",
		"~r~Ein Fehler ist aufgetreten~s~", "");
	DrawNotification(false, true);

	noMoneyError = true
	print(noMoneyError)
	print("--- error ---")
end)

Citizen.CreateThread(function()
	while true do

		local isInMarker = false
		local playerPed  = PlayerPedId()
		local coords     = GetEntityCoords(playerPed)

		Wait(0)
		DrawMarker(1, -1154.96, -2151.83, 12.20, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 0.5, 200, 55, 50, 100, false, true,
			2,
			false, false, false, false)

		if GetDistanceBetweenCoords(coords, -1154.96, -2151.83, 13.26, true) < 1.5 then
			isInMarker = true
			ESX.ShowHelpNotification('Drücke ~INPUT_CONTEXT~ um dir ein GoKart zu mieten!')
		else
			isInMarker = false
		end
		if IsControlJustReleased(0, Keys['E']) and isInMarker == true then
			TriggerEvent("nui:on", true)
		end

	end
end)
