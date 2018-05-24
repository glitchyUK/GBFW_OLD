------------------------------------------------------------
------------------------------------------------------------
---- Author: Dylan 'Itokoyamato' Thuillier              ----
----                                                    ----
---- Email: itokoyamato@hotmail.fr                      ----
------------------------------------------------------------
------------------------------------------------------------

------------------------------------------------------------
-- Global variables
------------------------------------------------------------

Admin = setmetatable({}, Admin);
Admin.__index = Admin;

Admin.usersTags = {};
Admin.isHost = false;

Admin.distanceDisplay = 10; -- Distance head-tags are displayed at max
Admin.scale = 0.3; -- Scale of head-tags text
Admin.offsetX = 0; -- Offset 'X' for head-tags text
Admin.offsetY = 0; -- Offset 'Y' for head-tags text
Admin.offsetZ = 1.1; -- Offset 'Z' for head-tags text

Admin.vehicles = {	-- ['Vehicle name']  = permission_level(int)
					['EXEMPLAR'] = 15,
					['RHINO'] = 10,
				};

------------------------------------------------------------
-- Client: head-tag functions
------------------------------------------------------------

function Admin.updateTags(tags)
	Admin.usersTags = tags;
end
RegisterNetEvent("Admin:updateTags");
AddEventHandler("Admin:updateTags", Admin.updateTags);

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1);

		-- Head-tags
		local localCoords = GetEntityCoords(GetPlayerPed(-1));
		for id = 0, 512 do
			if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1) then

				local playerCoords = GetEntityCoords(GetPlayerPed(id));
				local playerPed = GetPlayerPed(id);
				if (GetDistanceBetweenCoords(localCoords, playerCoords) < Admin.distanceDisplay) then
					Citizen.InvokeNative( 0xBFEFE3321A3F5015, GetPlayerPed(id), "", false, false, "", false);
					if (Admin.usersTags[GetPlayerName(id)]) then
						DrawText3D(playerCoords.x + Admin.offsetX, playerCoords.y + Admin.offsetY, playerCoords.z + Admin.offsetZ, "~r~" .. Admin.usersTags[GetPlayerName(id)]);
						DrawText3D(playerCoords.x + Admin.offsetX, playerCoords.y + Admin.offsetY, playerCoords.z + Admin.offsetZ, "~r~" .. Admin.usersTags[GetPlayerName(id)] .. "\n~w~" .. id);
					else
						DrawText3D(playerCoords.x + Admin.offsetX, playerCoords.y + Admin.offsetY, playerCoords.z + Admin.offsetZ, "~w~" .. id);
					end
				end
			end
		end

		-- Vehicle restriction
		local ped = PlayerPedId();
		if (not IsPedInAnyVehicle(ped, false) and DoesEntityExist(GetVehiclePedIsTryingToEnter(ped))) then
			local veh_name = GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsTryingToEnter(ped)));
			if (Admin.vehicles[veh_name] and Admin.level < Admin.vehicles[veh_name]) then
				ClearPedTasksImmediately(ped);
			end
		end
	end
end);


------------------------------------------------------------
-- Client: Weather functions
------------------------------------------------------------

function Admin.setWeather(weather)
	if (weather) then
		if (weather == "NONE") then
			ClearOverrideWeather();
			ClearWeatherTypePersist();
		else
			SetWeatherTypePersist(weather);
			SetWeatherTypeNowPersist(weather);
			SetWeatherTypeNow(weather);
			SetOverrideWeather(weather);
		end
	end
end
RegisterNetEvent("Admin:setWeather");
AddEventHandler("Admin:setWeather", Admin.setWeather);


------------------------------------------------------------
-- Client: Time functions
------------------------------------------------------------

function Admin.setTime(hours, minutes, seconds)
	if (hours and minutes and seconds) then
		if (tonumber(hours) > 23 or tonumber(hours) < 0 or tonumber(minutes) > 59 or tonumber(minutes) < 0 or tonumber(seconds) > 59 or tonumber(seconds) < 0) then return; end
		NetworkOverrideClockTime(tonumber(hours), tonumber(minutes), tonumber(seconds));
	end
end
RegisterNetEvent("Admin:setTime");
AddEventHandler("Admin:setTime", Admin.setTime);

function Admin.syncTime()
	if (not Admin.isHost) then
		Citizen.CreateThread(function()
			while true do
				TriggerServerEvent("Admin:updateTime", GetClockHours(), GetClockMinutes(), GetClockSeconds());
				Wait(60000);
			end
		end);
		Admin.isHost = true;
	end
end
RegisterNetEvent("Admin:syncTime");
AddEventHandler("Admin:syncTime", Admin.syncTime);


------------------------------------------------------------
-- Client: Utils
------------------------------------------------------------

function Admin.updateLevel(level)
	Admin.level = level;
end
RegisterNetEvent("Admin:updateLevel");
AddEventHandler("Admin:updateLevel", Admin.updateLevel);

function DrawText3D(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z);
	local px, py, pz = table.unpack(GetEntityCoords(GetPlayerPed(-1)));

	if (onScreen) then
		SetTextScale(Admin.scale, Admin.scale);
		SetTextFont(0);
		SetTextProportional(1);
		SetTextColour(255, 255, 255, 255);
		SetTextDropshadow(0, 0, 0, 0, 255);
		SetTextEdge(2, 0, 0, 0, 150);
		SetTextDropShadow();
		SetTextOutline();
		SetTextEntry("STRING");
		SetTextCentre(1);
		AddTextComponentString(text);
		DrawText(_x, _y);
	end
end
