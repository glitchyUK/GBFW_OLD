------------------------------------------------------------
------------------------------------------------------------
---- Author: Dylan 'Itokoyamato' Thuillier              ----
----                                                    ----
---- Email: itokoyamato@hotmail.fr                      ----
------------------------------------------------------------
------------------------------------------------------------

addCommand("hlset", "", {}, function(src, args)
	local steamID = getPlayerSteamID(src);
	if (args[1] and args[1] ~= "") then
		Admin.usersTag[GetPlayerName(src)] = args[2];
		Admin.updateTags();
		TriggerClientEvent('chatMessage', src, "", {255, 0, 0}, "^3(INFO) You have set your headlabel to [ " .. args[1] .. " ]");
	else
		TriggerClientEvent('chatMessage', src, "", {255, 0, 0}, "^3(INFO) Invalid Headlabel Specified");
	end
end, 1) -- Admin level

addCommand("hldel", "", {}, function(src, args)
	local steamID = getPlayerSteamID(src);
	Admin.usersTag[GetPlayerName(src)] = nil;
	Admin.updateTags();
	TriggerClientEvent('chatMessage', src, "", {255, 0, 0}, "^3(INFO) You have removed your headlabel");
end, 1) -- Admin level

addCommand("weather", "", {}, function(src, args)
	if (args[1] and Admin.weathers[string.upper(args[1])]) then
		Admin.currentWeather = string.upper(args[1]);
		Admin.updateWeather();
		TriggerClientEvent('chatMessage', src, "", {255, 0, 0}, "^3(INFO) You have set the weather to [ " .. Admin.currentWeather .. " ]");
	else
		TriggerClientEvent('chatMessage', src, "", {255, 0, 0}, "^3(INFO) Invalid Weather Specified");
	end
end, 1) -- Admin level

addCommand("time", "", {}, function(src, args)
	if (args[1] and args[2]) then
			Admin.updateTime(args[1], args[2], 0);
		TriggerClientEvent('chatMessage', src, "", {255, 0, 0}, "^3(INFO) You have set the time to [ " .. args[1] .. ":" .. args[2] .. " ]");
	else
		TriggerClientEvent('chatMessage', src, "", {255, 0, 0}, "^3(INFO) Invalid Time Specified");
	end
end, 1) -- Admin level