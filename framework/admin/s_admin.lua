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

Admin.usersTag = {};
Admin.weathers = {	
					["EXTRASUNNY"] = true,
					["CLEAR"] = true,
					["CLOUDS"] = true,
					["OVERCAST"] = true,
					["SMOG"] = true,
					["FOGGY"] = true,
					["RAIN"] = true,
					["THUNDER"] = true,
					["CLEARING"] = true,
					["NEUTRAL"] = true,
					["SNOW"] = true,
					["BLIZZARD"] = true,
					["XMAS"] = true,
					["NONE"] = true
				};
Admin.currentWeather = "CLEAR";

function Admin.updateTags()
	TriggerClientEvent("Admin:updateTags", -1, Admin.usersTag);
end

function Admin.updateWeather()
	TriggerClientEvent('Admin:setWeather', -1, Admin.currentWeather);
end

function Admin.updateTime(hours, minutes, seconds)
	TriggerClientEvent('Admin:setTime', -1, hours, minutes, seconds);
end
RegisterServerEvent("Admin:updateTime");
AddEventHandler("Admin:updateTime", Admin.updateTime);


------------------------------------------------------------
-- Utils
------------------------------------------------------------

function Admin.playerDropped(reason)
	if (Admin.usersTag[GetPlayerName(source)]) then
		Admin.usersTag[GetPlayerName(source)] = nil;
		Admin.updateTags();
	end
	if (GetHostId()) then
		TriggerClientEvent('Admin:syncTime', GetHostId());
	end
end
AddEventHandler("playerDropped", Admin.playerDropped);

AddEventHandler("onClientPlayerReady", function(source)
	Admin.updateTags();
	Admin.updateWeather();
	if (GetHostId()) then
		TriggerClientEvent('Admin:syncTime', GetHostId());
	end
end);

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function getPlayerSteamID(player)
	local identifiers = GetPlayerIdentifiers(player);
	for i = 1, #identifiers do
		if (string.match(identifiers[i], "steam")) then
			return (tostring(tonumber(string.gsub(identifiers[i], "steam:", ""), 16)));
		end
	end
end