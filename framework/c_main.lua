Framework = setmetatable({}, Framework);
Framework.__index = Framework;
Framework.playerReady = false;
Framework.playersData = {};

allowedWeapons = { --"WEAPON_UNARMED",
  "WEAPON_KNIFE", 
  "WEAPON_NIGHTSTICK", 
  "WEAPON_HAMMER", 
  "WEAPON_BAT", 
  "WEAPON_GOLFCLUB", 
  "WEAPON_CROWBAR",
  "WEAPON_PISTOL", 
  "WEAPON_COMBATPISTOL", 
  "WEAPON_APPISTOL", 
  "WEAPON_PISTOL50", 
  "WEAPON_MICROSMG", 
  "WEAPON_SMG", 
  "WEAPON_ASSAULTSMG", 
  "WEAPON_ASSAULTRIFLE", 
  "WEAPON_CARBINERIFLE", 
  --"WEAPON_ADVANCEDRIFLE", 
  --"WEAPON_MG", 
  --"WEAPON_COMBATMG", 
  "WEAPON_PUMPSHOTGUN", 
  "WEAPON_SAWNOFFSHOTGUN", 
  --"WEAPON_ASSAULTSHOTGUN", 
  "WEAPON_BULLPUPSHOTGUN", 
  "WEAPON_STUNGUN", 
  --"WEAPON_SNIPERRIFLE", 
  --"WEAPON_SMOKEGRENADE", 
  --"WEAPON_BZGAS", 
  --"WEAPON_MOLOTOV", 
  "WEAPON_FIREEXTINGUISHER", 
  "WEAPON_PETROLCAN", 
  "WEAPON_SNSPISTOL", 
  --"WEAPON_SPECIALCARBINE", 
  "WEAPON_HEAVYPISTOL", 
  --"WEAPON_BULLPUPRIFLE", 
  --"WEAPON_HOMINGLAUNCHER", 
  --"WEAPON_PROXMINE", 
  --"WEAPON_SNOWBALL", 
  "WEAPON_VINTAGEPISTOL", 
  "WEAPON_DAGGER", 
  --"WEAPON_FIREWORK", 
  "WEAPON_MUSKET", 
  --"WEAPON_MARKSMANRIFLE", 
  "WEAPON_HEAVYSHOTGUN", 
  "WEAPON_GUSENBERG", 
  "WEAPON_HATCHET", 
  "WEAPON_COMBATPDW", 
  "WEAPON_KNUCKLE", 
  --"WEAPON_MARKSMANPISTOL", 
  "WEAPON_BOTTLE", 
  "WEAPON_FLAREGUN", 
  "WEAPON_FLARE", 
  "WEAPON_REVOLVER", 
  "WEAPON_SWITCHBLADE", 
  "WEAPON_MACHETE", 
  "WEAPON_FLASHLIGHT", 
  --"WEAPON_MACHINEPISTOL", 
  "WEAPON_DBSHOTGUN", 
  "WEAPON_COMPACTRIFLE",
  "WEAPON_KnuckleDuster",
  "WEAPON_DoubleBarrelShotgun"
}

function Framework.init()
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), "FE_THDR_GTAO", "Role Play")
	Citizen.Trace("JCRP: Initialized2\n");
	spawnPlayer();
	setAutoSpawn(true);
	SetNuiFocus(false);
	DoScreenFadeIn(0.0);
	Framework.setLocalPlayerData("state", "joining", true);
	NetworkSetTalkerProximity(15);
	Citizen.CreateThread(function()
		while true do
			Wait(10000);
			if (Account.me.currentCharacter) then
				Account.saveData();
			end
		end
	end);
end
AddEventHandler("onClientGameTypeStart", Framework.init);

AddEventHandler('onClientMapStart', function()
	NetworkSetTalkerProximity(15) -- 50 meters range
end);

AddEventHandler("reselectCharacter", function()
	Framework.playerReady = false;
	Framework.playersData = {};
end)

function Framework.onPlayerSpawned(spawn)
	Citizen.Trace("Framework: spawned");
	SetNuiFocus(false);
	setPlayerInvisible(true);
	setPlayerFrozen(true);
	
	Citizen.CreateThread(function()
		Citizen.Wait(50);
		
		if (ModelName == "" or ModelName == nil) then
			local hash = GetHashKey('S_M_Y_Dealer_01')
			RequestModel(hash);
			while not HasModelLoaded(hash) do
				Citizen.Wait(5);
			end
			
			SetPlayerModel(PlayerId(), hash);
			SetPedDefaultComponentVariation(GetPlayerPed(-1));
			SetModelAsNoLongerNeeded(hash);
			if (not Framework.playerReady) then
				TriggerEvent("onClientPlayerReady");
				TriggerServerEvent("onClientPlayerReady");
				Framework.playerReady = true;
				Citizen.Trace("Framework: player ready");
			else
				SetEntityCoords(GetPlayerPed(-1), 338.948, -1394.848, 32.5092);
			end
		end
	end)
end
AddEventHandler("playerSpawned", Framework.onPlayerSpawned);

function Framework.setPlayerData(playername, key, data, shared)
	if (not Framework.playersData[playername]) then
		Framework.playersData[playername] = {};
	end
	Framework.playersData[playername][key] = data;
	if (shared) then
		TriggerServerEvent("Framework:setPlayerData", playername, key, data);
	end
end
RegisterNetEvent("Framework:setPlayerData");
AddEventHandler("Framework:setPlayerData", Framework.setPlayerData);

function Framework.getLocalPlayerData(key)
	local playername = GetPlayerName(PlayerId());
	if (not Framework.playersData[playername]) then return false; end
	return Framework.playersData[playername][key] or false;
end

function Framework.setLocalPlayerData(key, data, shared)
	local playername = GetPlayerName(PlayerId());
	if (not Framework.playersData[playername]) then
		Framework.playersData[playername] = {};
	end
	Framework.playersData[playername][key] = data;
	if (shared) then
		TriggerServerEvent("Framework:setPlayerData", playername, key, data);
	end
end

RegisterNetEvent("reselectCharacter");
