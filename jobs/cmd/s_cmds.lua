------------------------------------------------------------
------------------------------------------------------------
---- Author: Dylan 'Itokoyamato' Thuillier              ----
----                                                    ----
---- Email: itokoyamato@hotmail.fr                      ----
------------------------------------------------------------
------------------------------------------------------------
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
