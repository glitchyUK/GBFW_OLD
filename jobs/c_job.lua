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

Jobs = setmetatable({}, Jobs);
Jobs.__index = Jobs;

Jobs.myJob = false;

Jobs.mdt = {};
Jobs.mdt.charges = {};

Jobs.cuffed = false;
Jobs.jailed = false;
Jobs.jail = {};
Jobs.jail.pos = {x = 1690.0, y = 2535.0, z = 46.0};
Jobs.jail.pos_entry = {x = 1691.7, y = 2564.94, z = 46.0};
Jobs.jail.pos_release = {x = 1846.48, y = 2586.04, z = 46.0};
Jobs.jail.distance = 80.0;

Police = setmetatable({}, Police);
Police.__index = Police;

Police.stations = {
	["Vaspucci Police Station"] = {
		locker = {x = 458.2284, y = -992.3896, z = 29.68961},
		garage = {x = 447.5736, y = -1021.329, z = 27.44965, heading = 85.001},
		vehicles = {
			{name = "cruiser", hash = "police"},
			{name = "bike", hash = "policeb"},
			{name = "cruiser2", hash = "police2"},
			{name = "cruiser3", hash = "police3"},
			{name = "unmarked", hash = "police4"}
		}
	}
}

------------------------------------------------------------
-- Client: head-tag functions
------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1);
		-- Disable emergency npc
		for i = 1, 32 do
			Citizen.InvokeNative(0xDC0F817884CDD856, i, false);
		end

		-- MDT display
		if (#Jobs.mdt.charges > 0) then
			drawTxt2(0.505, 0.890, 1.0,1.0,0.45, "~b~Charges:", 255, 255, 255, 200);
			for i = 1, #Jobs.mdt.charges do
				drawTxt2(0.505, 0.890 + i*0.021, 1.0,1.0,0.45, "[" .. Jobs.mdt.charges[i].timestamp .. "] " .. Jobs.mdt.charges[i].charge .. " (by " .. Jobs.mdt.charges[i].officer_username .. " - " .. Jobs.mdt.charges[i].officer_charID .. ")", 255, 255, 255, 200);
				if (i == #Jobs.mdt.charges) then
					drawTxt2(0.505, 0.890 + (i + 2)*0.021, 1.0,1.0,0.35, "Press ~r~DEL ~w~to close this info", 255, 255, 255, 200);
				end
			end
			if (IsControlJustPressed(0, 178)) then
				Jobs.mdt.charges = {};
				Jobs.mdt.playerName = nil;
			end
		end
		--

		-- Handcuffs system
		if (Jobs.cuffed) then
			DisableControlAction(1, 18, true);
			DisableControlAction(1, 24, true);
			DisableControlAction(1, 69, true);
			DisableControlAction(1, 92, true);
			DisableControlAction(1, 106, true);
			DisableControlAction(1, 122, true);
			DisableControlAction(1, 135, true);
			DisableControlAction(1, 142, true);
			DisableControlAction(1, 144, true);
			DisableControlAction(1, 176, true);
			DisableControlAction(1, 223, true);
			DisableControlAction(1, 229, true);
			DisableControlAction(1, 237, true);
			DisableControlAction(1, 257, true);
			DisableControlAction(1, 329, true);
			DisableControlAction(1, 80, true);
			DisableControlAction(1, 140, true);
			DisableControlAction(1, 250, true);
			DisableControlAction(1, 263, true);
			DisableControlAction(1, 310, true);

			DisableControlAction(1, 22, true);
			DisableControlAction(1, 55, true);
			DisableControlAction(1, 76, true);
			DisableControlAction(1, 102, true);
			DisableControlAction(1, 114, true);
			DisableControlAction(1, 143, true);
			DisableControlAction(1, 179, true);
			DisableControlAction(1, 193, true);
			DisableControlAction(1, 203, true);
			DisableControlAction(1, 216, true);
			DisableControlAction(1, 255, true);
			DisableControlAction(1, 298, true);
			DisableControlAction(1, 321, true);
			DisableControlAction(1, 328, true);
			DisableControlAction(1, 331, true);
			DisableControlAction(0, 63, false);
			DisableControlAction(0, 64, false);
			DisableControlAction(0, 59, false);
			DisableControlAction(0, 278, false);
			DisableControlAction(0, 279, false);
			DisableControlAction(0, 68, false);
			DisableControlAction(0, 69, false);
			DisableControlAction(0, 75, false);
			DisableControlAction(0, 76, false);
			DisableControlAction(0, 102, false);
			DisableControlAction(0, 81, false);
			DisableControlAction(0, 82, false);
			DisableControlAction(0, 83, false);
			DisableControlAction(0, 84, false);
			DisableControlAction(0, 85, false);
			DisableControlAction(0, 86, false);
			DisableControlAction(0, 106, false);
			DisableControlAction(0, 25, false);

			while not HasAnimDictLoaded('mp_arresting') do
				RequestAnimDict('mp_arresting')
				Citizen.Wait(5)
			end

			if not IsEntityPlayingAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 3) then
				TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
			end
		end
		--

		-- Jail system
		if (Jobs.jailed) then
			if (GetDistanceBetweenCoords(Jobs.jail.pos.x, Jobs.jail.pos.y, Jobs.jail.pos.z, GetEntityCoords(GetPlayerPed(-1)), false) >= Jobs.jail.distance) then
				SetEntityCoords(GetPlayerPed(-1), Jobs.jail.pos_entry.x, Jobs.jail.pos_entry.y, Jobs.jail.pos_entry.z, 0.0, 0.0, 0.0);
			end
		end
		--

		-- Handsup system
		if (IsControlPressed(1, 323)) then
			TaskHandsUp(GetPlayerPed(-1), 100, -1, -1, true)
		end
		--

		local myAccount = exports.framework:myAccount();
		for i, station in pairs(Police.stations) do
			if (myAccount and myAccount.currentCharacter and myAccount.currentCharacter.job == "police") then
				local lockerDistance = GetDistanceBetweenCoords(station.locker.x, station.locker.y, station.locker.z, GetEntityCoords(GetPlayerPed(-1)), true);
				if (lockerDistance < 20) then
					DrawMarker(1, station.locker.x, station.locker.y, station.locker.z,0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,200,0,0,0,0);
				end

				if (lockerDistance < 2) then
					if (Jobs.myJob == "police") then
						drawTxt("Press [~r~E~s~] to clock out",0,1,0.5,0.8,0.6,255,255,255,255);
					else
						drawTxt("Press [~r~E~s~] to clock in",0,1,0.5,0.8,0.6,255,255,255,255);
					end
					if (IsControlJustPressed(1, 38)) then
						if (Jobs.myJob == "police") then
							TriggerServerEvent("Jobs:clock", "police", false);
						elseif (not Jobs.myJob) then
							TriggerServerEvent("Jobs:clock", "police", true);
						end
					end
				end

				local garageDistance = GetDistanceBetweenCoords(station.garage.x, station.garage.y, station.garage.z, GetEntityCoords(GetPlayerPed(-1)), true);
				if (garageDistance < 20) then
					DrawMarker(1, station.garage.x, station.garage.y, station.garage.z,0,0,0,0,0,0,2.001,2.0001,0.5001,0,155,255,200,0,0,0,0);
				end

				if (garageDistance < 2) then
					if (Jobs.myJob == "police") then
						drawTxt("Press [~r~E~s~] to get the vehicle list",0,1,0.5,0.8,0.6,255,255,255,255);
					end
					if (IsControlJustPressed(1, 38)) then
						TriggerEvent("chat:addMessage", {color={255,255,255},args={"Police vehicles:"}});
						for i, veh in pairs(station.vehicles) do
							TriggerEvent("chat:addMessage", {color={255,255,255},args={"- " .. veh.name}});
						end
						TriggerEvent("chat:addMessage", {color={255,255,255},args={"Usage: /police spawn [name]"}});
					end
				end
			end
		end

	end
end);


------------------------------------------------------------
-- Client: Job functions
------------------------------------------------------------

function Jobs.join(job)
	Jobs.myJob = job;
	if (job == "police") then
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_CARBINERIFLE"), 500, true, false);
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PUMPSHOTGUN"), 500, true, false);
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), 500, true, false);
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), 500, true, false);
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_NIGHTSTICK"), 500, true, false);
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_COMBATPISTOL"), 500, true, false);
	elseif (job == "fire" or job == "ems") then
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FIREEXTINGUISHER"), 500, true, false);
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_HATCHET"), 500, true, false);
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_FLASHLIGHT"), 500, true, false);
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_STUNGUN"), 500, true, false);
	end
end
RegisterNetEvent("Jobs:join");
AddEventHandler("Jobs:join", Jobs.join);

function Jobs.leave()
	Jobs.myJob = false;
end
RegisterNetEvent("Jobs:leave");
AddEventHandler("Jobs:leave", Jobs.leave);


------------------------------------------------------------
-- Client: Police functions
------------------------------------------------------------

function Jobs.displayCharges(playerName, charges)
	Citizen.Trace("hi");
	Jobs.mdt.charges = charges;
	Jobs.mdt.playerName = playerName;
	Jobs.mdt.bolos = {};
	Jobs.mdt.plate = {};
	Jobs.mdt.display = false;
end
RegisterNetEvent("Jobs:displayCharges");
AddEventHandler("Jobs:displayCharges", Jobs.displayCharges);

function Jobs.displayMDT()
	Jobs.mdt.charges = {};
	Jobs.mdt.playerName = nil;
	Jobs.mdt.bolos = {};
	Jobs.mdt.plate = {};
	Jobs.mdt.display = true;
end
RegisterNetEvent("Jobs:displayMDT");
AddEventHandler("Jobs:displayMDT", Jobs.displayMDT);

function Jobs.cuff(state)
	Jobs.cuffed = state;
	if (state) then
		SetPedCanSwitchWeapon(GetPlayerPed(-1), false);
	else
		StopAnimTask(GetPlayerPed(-1), 'mp_arresting', 'idle', 1.0);
		SetPedCanSwitchWeapon(GetPlayerPed(-1), true);
	end
end
RegisterNetEvent("Jobs:cuff");
AddEventHandler("Jobs:cuff", Jobs.cuff);

function Jobs.do_jail(state, time)
	Citizen.Trace("hi");
	if (state) then
		if (GetDistanceBetweenCoords(Jobs.jail.pos.x, Jobs.jail.pos.y, Jobs.jail.pos.z, GetEntityCoords(GetPlayerPed(-1)), false) >= Jobs.jail.distance) then
			SetEntityCoords(GetPlayerPed(-1), Jobs.jail.pos_entry.x, Jobs.jail.pos_entry.y, Jobs.jail.pos_entry.z, 0.0, 0.0, 0.0);
		end
		drawNotification("You are in jail. You have " .. time .. " minutes remaining.");
	else
		SetEntityCoords(GetPlayerPed(-1), Jobs.jail.pos_release.x, Jobs.jail.pos_release.y, Jobs.jail.pos_release.z, 0.0, 0.0, 0.0);
		drawNotification("You have served your time in jail. You are free !");
	end
	Jobs.jailed = state;
end
RegisterNetEvent("Jobs:jail");
AddEventHandler("Jobs:jail", Jobs.do_jail);


------------------------------------------------------------
-- Client: Utils
------------------------------------------------------------

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)	
end

function drawTxt2(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(2, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(true, true)
end
