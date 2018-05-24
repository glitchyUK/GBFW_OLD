------------------------------------------------------------
------------------------------------------------------------
---- Author: Dylan 'Itokoyamato' Thuillier              ----
----                                                    ----
---- Email: itokoyamato@hotmail.fr                      ----
------------------------------------------------------------
------------------------------------------------------------
addCommand("kick","",{
	{"PlayerID"},{"[Reason]","Optional"}
},function(src,args)
	local target = tonumber(args[1])
	if not target then
		return "^3(INFO) Invalid Player Specified"
	end

	DropPlayer(target,args[2] or "You got kicked.")
	return "^3(INFO) Kick issued for [ " .. target .. " | " .. GetPlayerName(target) .. " ] by [ " .. src .. " | " .. GetPlayerName(src) .. " ]"
end,1) -- Admin level

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

addCommand("cuff", "/cuff [playerID]", {}, function(src, args)
	local steamID = getPlayerSteamID(src);
	local target = tonumber(args[1]);
	if (Jobs.police.users[steamID]) then
		if (not target or not GetPlayerName(target)) then
			TriggerClientEvent("chatMessage", src, "",{255, 255, 255}, "^1Player ID is invalid.");
		else
			TriggerClientEvent("Jobs:cuff", target, true);
			TriggerClientEvent("chatMessage", src, "",{255, 255, 255}, "^4Police: ^1You have cuffed " .. GetPlayerName(target));
			TriggerClientEvent("chatMessage", target, "",{255, 255, 255}, "^4Police: ^1You have been cuffed by " .. GetPlayerName(src));
		end
	end
end, 0) -- Admin level

addCommand("uncuff", "/uncuff [playerID]", {}, function(src, args)
	local steamID = getPlayerSteamID(src);
	local target = tonumber(args[1]);
	if (Jobs.police.users[steamID]) then
		if (not target or not GetPlayerName(target)) then
			TriggerClientEvent("chatMessage", src, "",{255, 255, 255}, "^1Player ID is invalid.");
		else
			TriggerClientEvent("Jobs:cuff", target, false);
			TriggerClientEvent("chatMessage", src, "",{255, 255, 255}, "^4Police: ^1You have uncuffed " .. GetPlayerName(target));
			TriggerClientEvent("chatMessage", target, "",{255, 255, 255}, "^4Police: ^1You have been uncuffed by " .. GetPlayerName(src));
		end
	end
end, 0) -- Admin level

addCommand("jail", "/jail [playerID]", {}, function(src, args)
	local steamID = getPlayerSteamID(src);
	local target = tonumber(args[1]);
	if (Jobs.police.users[steamID]) then
		if (not target or not GetPlayerName(target)) then
			TriggerClientEvent("chatMessage", src, "",{255, 255, 255}, "^1Player ID is invalid.");
		else
			if (not args[2]) then
				sendUsage(src, "jail");
			else
				Jobs.jail.users[#Jobs.jail.users + 1] = {player = args[1], time = args[2]*60};
				TriggerClientEvent("Jobs:jail", args[1], true, args[2]);
				TriggerClientEvent("chatMessage", -1, "",{255, 255, 255}, "^4Jail: ^0" .. GetPlayerName(args[1]) .. " was sent to jail for " .. args[2] .. " minutes - by " .. GetPlayerName(src) .. ".");
			end
		end
	end
end, 0) -- Admin level

addCommand("pedc", "/pedc [playerID]", {}, function(src, args)
	local steamID = getPlayerSteamID(src);
	if (Jobs.police.users[steamID]) then
		if (not args[1] or not GetPlayerName(args[1])) then
			TriggerClientEvent("chatMessage", src, "",{255, 255, 255}, "^1Player ID is invalid.");
		else
			Jobs.displayPlayerCharges(src, args[1]);
		end
	end
end, 0) -- Admin level

addCommand("charge", "/charge [playerID]", {}, function(src, args)
	local steamID = getPlayerSteamID(src);
	if (Jobs.police.users[steamID]) then
		if (not args[1] or not GetPlayerName(args[1])) then
			TriggerClientEvent("chatMessage", src, "",{255, 255, 255}, "^1Player ID is invalid.");
		else
			if (not args[2]) then
				sendUsage(src, "charge");
			else
				local str = "";
				for i = 2, #args do
					if (str == "") then
						str = args[i];
					else
						str = str .. " " .. args[i];
					end
				end
				Jobs.givePlayerCharge(src, args[1], str);
			end
		end
	end
end, 0) -- Admin level
