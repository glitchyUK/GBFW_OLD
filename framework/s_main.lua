------------------------------------------------------------
------------------------------------------------------------
---- Author: Dylan 'Itokoyamato' Thuillier              ----
----                                                    ----
---- Email: itokoyamato@hotmail.fr                      ----
------------------------------------------------------------
------------------------------------------------------------
local Framework = setmetatable({}, Framework);
Framework.__index = Framework;

playerList = {};

function Framework.setPlayerData(playername, key, data)
	TriggerClientEvent("Framework:setPlayerData", -1, playername, key, data);
end
RegisterServerEvent("Framework:setPlayerData");
AddEventHandler("Framework:setPlayerData", Framework.setPlayerData);

function onResourceStart(resourceName)
	if (resourceName == "framework") then
		StopResource("mysql-async");
		StartResource("mysql-async");
		Citizen.CreateThread(function()
			while true do
				Wait(10000);
				for i, account in pairs(playerList) do
					if (account.currentCharacter) then
						Account.save(account);
					end
				end
			end
		end);
	end
end
RegisterServerEvent("onResourceStart");
AddEventHandler("onResourceStart", onResourceStart);

AddEventHandler('playerDropped', function()
	local steamid = tonumber(GetPlayerIdentifiers(source)[1]:gsub("steam:", ""), 16);
	if (playerList[steamid]) then
		playerList[steamid] = nil;
	end
end)

function ensureFloat(number)
	if math.modf(number) == 0 then
		return number + .0001
	end
	
	return number		
end

function getPlayerList()
	return playerList;
end

function getPlayerSteamID(player)
	local identifiers = GetPlayerIdentifiers(player);
	for i = 1, #identifiers do
		if (string.match(identifiers[i], "steam")) then
			return (tostring(tonumber(string.gsub(identifiers[i], "steam:", ""), 16)));
		end
	end
end

--------------------------------------------------------------------------------
--	Utils: Table functions
--------------------------------------------------------------------------------

function table.val_to_str (v)
	if ("string" == type(v)) then
		v = string.gsub(v, "\n", "\\n");
		if (string.match(string.gsub(v, "[^'\"]", ""), '^"+$')) then
			return ("'"..v.."'");
		end
		return ('"'..string.gsub(v, '"', '\\"')..'"');
	else
		return ("table" == type(v) and table.tostring(v) or tostring(v));
	end
end

function table.key_to_str (k)
	if ("string" == type(k) and string.match(k, "^[_%a][_%a%d]*$")) then
		return (k);
	else
		return ("["..table.val_to_str(k).."]");
	end
end

function table.tostring(tbl)
	local result, done = {}, {};
	for k, v in ipairs(tbl) do
		table.insert(result, table.val_to_str(v));
		done[k] = true;
	end
	for k, v in pairs(tbl) do
		if (not done[k]) then
			table.insert(result, table.key_to_str(k).."="..table.val_to_str(v));
		end
	end
	return ("{"..table.concat(result, ",").."}");
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end