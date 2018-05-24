------------------------------------------------------------
------------------------------------------------------------
---- Author: Dylan 'Itokoyamato' Thuillier              ----
----                                                    ----
---- Email: itokoyamato@hotmail.fr                      ----
------------------------------------------------------------
------------------------------------------------------------
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
				drawTxt("Retrieving Your Account",2,1,0.5,0.5,0.8, 240,143,143,255);
			elseif (not Account.me.currentCharacter) then
				drawTxt("Select Your Character",2,1,0.5,0.15,0.8, 255,255,255,255);
				drawTxt("/CHAR SELECT [ID]\n/CHAR CREATE [FIRSTNAME] [LASTNAME]",4,1,0.5,0.2,0.4, 255,255,255,255);
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