addCommand("hlset", "", {}, function(src, args)
	local steamID = getPlayerSteamID(src);
	if (args[1] and args[1] ~= "") then
		Admin.usersTag[GetPlayerName(src)] = args[2];
		Admin.updateTags();
		TriggerClientEvent('chatMessage', src, "SYSTEM", {255, 0, 0}, "You have set your head-tag to ^4'^1" .. args[1] .. "^4'^0");
	else
		TriggerClientEvent('chatMessage', src, "SYSTEM", {255, 0, 0}, "^4Usage:^1 /hlset ^4[^1string^4]^1");
	end
end, 1) -- Admin level

addCommand("hldel", "", {}, function(src, args)
	local steamID = getPlayerSteamID(src);
	Admin.usersTag[GetPlayerName(src)] = nil;
	Admin.updateTags();
	TriggerClientEvent('chatMessage', src, "SYSTEM", {255, 0, 0}, "You have ^1removed^0 your head-tag");
end, 1) -- Admin level

addCommand("weather", "", {}, function(src, args)
	if (args[1] and Admin.weathers[string.upper(args[1])]) then
		Admin.currentWeather = string.upper(args[1]);
		Admin.updateWeather();
		TriggerClientEvent('chatMessage', src, "SYSTEM", {255, 0, 0}, "You have ^1changed^0 the weather to ^4'^1" .. args[1] .. "^4'^0");
	else
		TriggerClientEvent('chatMessage', src, "SYSTEM", {255, 0, 0}, "^4Usage:^1 /weather ^4[^1string^4]^1");
	end
end, 1) -- Admin level

addCommand("time", "", {}, function(src, args)
	if (args[1] and args[2]) then
			Admin.updateTime(args[1], args[2], 0);
		TriggerClientEvent('chatMessage', src, "SYSTEM", {255, 0, 0}, "You have ^1changed^0 the time to ^4'^1" .. args[1] .. ":" .. args[2] .. "^4'^0");
	else
		TriggerClientEvent('chatMessage', src, "SYSTEM", {255, 0, 0}, "^4Usage:^1 /time ^4[^1hour^4] [^1minutes^4]^1");
	end
end, 1) -- Admin level