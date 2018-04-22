local Lobby = setmetatable({}, Lobby);
Lobby.__index = Lobby;

Lobby.hideScreen = true;

AddEventHandler("reselectCharacter", function()
	Lobby.hideScreen = true;
end)

function Lobby.playerReady()
	Framework.setLocalPlayerData("state", "Lobby", true);
	Lobby.hideScreen = false;
	DoScreenFadeIn(3000);

	TriggerServerEvent("Account:login");

	Citizen.CreateThread(function()
		while not Account.me.currentCharacter do
			Wait(5);
			DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 200);
			DrawRect(0.5, 0.5, 0.5, 0.8, 0, 0, 0, 200);
			if (not Account.me.isLoggedIn) then
				drawTxt("Retrieving your account",1,1,0.5,0.5,0.8, 255,255,255,255);
			elseif (not Account.me.currentCharacter) then
				drawTxt("Select your character",1,1,0.5,0.15,0.8, 255,255,255,255);
				drawTxt("/char select [ID]\n/char create [firstname] [lastname]",0,1,0.5,0.2,0.5, 255,255,255,255);
				for i, row in ipairs(Account.me.characters) do
					drawTxt("- ID: " .. row.id .. " | " .. row.firstname .. " " .. row.lastname .. " | Money: " .. row.money,0,1,0.5,0.2 + i*0.1,0.5, 255,255,255,255);
				end
			end
		end
	end);
end
RegisterNetEvent("onClientPlayerReady");
AddEventHandler("onClientPlayerReady", Lobby.playerReady);

function getPlayerSteamID()
	return Account.me.steamid
end