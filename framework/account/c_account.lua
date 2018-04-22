Account = {};
Account.__index = Account;

Account.me = {};
Account.me.loggedIn = false;
Account.me.currentCharacter = false;

function Account.login(account)
	Citizen.Trace("Framework: player logged in");
	Account.me = account;
end
RegisterNetEvent("onClientPlayerLogin");
AddEventHandler("onClientPlayerLogin", Account.login);

function Account.loadCharacter(char)
	if (not char.modelName or char.modelName == "") then char.modelName = "S_M_Y_Dealer_01"; end

	local hash = GetHashKey(char.modelName)
	if (not IsModelInCdimage(hash) or not IsModelValid(hash)) then hash = GetHashKey("S_M_Y_Dealer_01"); end
	RequestModel(hash);
	while not HasModelLoaded(hash) do
		Citizen.Wait(5);
    end
	
	SetPlayerModel(PlayerId(), hash);
	SetPedDefaultComponentVariation(GetPlayerPed(-1));
	SetModelAsNoLongerNeeded(hash);

	Wait(500)
	if (tonumber(char.pos_x) ~= 0) then
		SetEntityCoords(GetPlayerPed(-1), tonumber(char.pos_x), tonumber(char.pos_y), tonumber(char.pos_z));
	else
		SetEntityCoords(GetPlayerPed(-1), 338.948, -1394.848, 32.5092);
	end

	Wait(500);

	SetPlayerHealthRechargeMultiplier(PlayerId(), 0.05);
	SetPlayerWeaponDefenseModifier(PlayerId(), 0.2);
	SetPlayerMeleeWeaponDefenseModifier(PlayerId(), 0.2);
	SetPlayerVehicleDefenseModifier(PlayerId(), 0.2);
	SetPedMaxHealth(GetPlayerPed(-1), 275);

	for i=1,#char.weapons do
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(char.weapons[i].weaponHash), 1, true, true);
		AddAmmoToPed(GetPlayerPed(-1), GetHashKey(char.weapons[i].weaponHash), char.weapons[i].ammocount);
	end

	setPlayerInvisible(false);
	setPlayerFrozen(false);

	Account.me.currentCharacter = char;
	Citizen.Trace("Framework: loaded character");
end
RegisterNetEvent("Account:loadCharacter");
AddEventHandler("Account:loadCharacter",  Account.loadCharacter);

function Account.saveData()
	local pos = GetEntityCoords(GetPlayerPed(-1));
	local heading = GetEntityHeading(GetPlayerPed(-1));
	local weapons = {}

	pos = {x = pos.x, y = pos.y, z = pos.z};
	for i=1, #allowedWeapons do
		if (HasPedGotWeapon(GetPlayerPed(-1), GetHashKey(allowedWeapons[i]))) then
			local ammo = GetAmmoInPedWeapon(GetPlayerPed(-1), GetHashKey(allowedWeapons[i]))
			weapons[#weapons+1] = {weaponHash = allowedWeapons[i], ammocount = ammo};
		end
	end
	TriggerServerEvent("Account:updateData", pos, heading, weapons);
	Citizen.Trace("Framework: updating data");
end
RegisterNetEvent("Account:loadCharacter");
AddEventHandler("Account:loadCharacter",  Account.loadCharacter);

function myAccount()
	return Account.me;
end
