------------------------------------------------------------
-- Global variables
------------------------------------------------------------

Jobs = setmetatable({}, Jobs);
Jobs.__index = Jobs;

Jobs.police = {};
Jobs.police.users = {};
Jobs.fire = {};
Jobs.fire.users = {};
Jobs.ems = {};
Jobs.ems.users = {};
Jobs.jail = {};
Jobs.jail.users = {};
Jobs.jail.password = "pass"; -- Jail password


------------------------------------------------------------
-- Server: Command handlers
------------------------------------------------------------

function Jobs.clock(job, toggle)
	local steamID = getPlayerSteamID(source);
	if (toggle) then
		Jobs[job].users[steamID] = {};
		TriggerClientEvent("Jobs:join", source, job);
	else
		Jobs[job].users[steamID] = nil;
		TriggerClientEvent("Jobs:leave", source);
	end
end
RegisterServerEvent("Jobs:clock");
AddEventHandler("Jobs:clock", Jobs.clock);

-- AddEventHandler("chatMessage", function(source, name, message)
-- 	local steamID = getPlayerSteamID(source);
-- 	local args = stringsplit(message, " ");
-- 	if (args[1] == "/job") then
-- 		CancelEvent();
-- 		if (args[2] == "police") then
-- 			if (not args[3]) then
-- 				sendUsage(source, "police");
-- 			else
-- 				if (Jobs.police.users[steamID]) then
-- 					TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Jobs: ^1You are already on the police job.");
-- 				elseif (Jobs.fire.users[steamID]) then
-- 					TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Jobs: ^1You are already on the firefighters job.");
-- 				elseif (Jobs.ems.users[steamID]) then
-- 					TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Jobs: ^1You are already on the ems job.");
-- 				else
-- 					Jobs.police.users[steamID] = {unit = args[3]};
-- 					TriggerClientEvent("Jobs:join", source, "police", args[3]);
-- 					TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Jobs: ^0You have joined the police job.");
-- 				end
-- 			end
-- 		elseif (args[2] == "fire") then
-- 			if (not args[3]) then
-- 				sendUsage(source, "fire");
-- 			else
-- 				if (Jobs.police.users[steamID]) then
-- 					TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Jobs: ^1You are already on the police job.");
-- 				elseif (Jobs.fire.users[steamID]) then
-- 					TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Jobs: ^1You are already on the firefighters job.");
-- 				elseif (Jobs.ems.users[steamID]) then
-- 					TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Jobs: ^1You are already on the ems job.");
-- 				else
-- 					Jobs.fire.users[steamID] = {unit = args[3]};
-- 					TriggerClientEvent("Jobs:join", source, "fire", args[3]);
-- 					TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Jobs: ^0You have joined the firefighter job.");
-- 				end
-- 			end
-- 		elseif (args[2] == "ems") then
-- 			if (not args[3]) then
-- 				sendUsage(source, "ems");
-- 			else
-- 				if (Jobs.police.users[steamID]) then
-- 					TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Jobs: ^1You are already on the police job.");
-- 				elseif (Jobs.fire.users[steamID]) then
-- 					TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Jobs: ^1You are already on the firefighters job.");
-- 				elseif (Jobs.ems.users[steamID]) then
-- 					TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Jobs: ^1You are already on the ems job.");
-- 				else
-- 					Jobs.ems.users[steamID] = {unit = args[3]};
-- 					TriggerClientEvent("Jobs:join", source, "ems", args[3]);
-- 					TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Jobs: ^0You have joined the EMS job.");
-- 				end
-- 			end
-- 		elseif (args[2] == "leave") then
-- 			if (Jobs.police.users[steamID]) then
-- 				Jobs.police.users[steamID] = nil;
-- 			elseif (Jobs.fire.users[steamID]) then
-- 				Jobs.fire.users[steamID] = nil;
-- 			elseif (Jobs.ems.users[steamID]) then
-- 				Jobs.ems.users[steamID] = nil;
-- 			end
-- 			TriggerClientEvent("Jobs:leave", source);
-- 			TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Jobs: ^0You have left your job.");
-- 		else
-- 			sendUsage(source, "all");
-- 		end
-- 	elseif (args[1] == "/mdt") then
-- 		CancelEvent();
-- 		if (Jobs.police.users[steamID]) then
-- 			if (not args[2]) then
-- 				TriggerClientEvent("Jobs:displayMDT", source);
-- 			elseif (args[2] == "platec") then
-- 				if (not args[3] or args[3] == "") then
-- 					TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4MDT: ^1Plate is invalid.");
-- 				else
-- 					TriggerClientEvent("Jobs:checkPlate", source, args[3]);
-- 				end
-- 			elseif (args[2] == "pedc") then
-- 				if (not args[3] or not GetPlayerName(args[3])) then
-- 					TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4MDT: ^1Player ID is invalid.");
-- 				else
-- 					Jobs.displayPlayerCharges(source, args[3]);
-- 				end
-- 			elseif (args[2] == "bolo" and args[3]) then
-- 				local str = "";
-- 				for i = 3, #args do
-- 					if (str == "") then
-- 						str = args[i];
-- 					else
-- 						str = str .. " " .. args[i];
-- 					end
-- 				end
-- 				Jobs.addBolo(source, str);
-- 			elseif (args[2] == "bolos") then
-- 				Jobs.displayBolos(source);
-- 			elseif (args[2] == "charge" and args[3] and GetPlayerName(args[3]) and args[4]) then
-- 				local str = "";
-- 				for i = 4, #args do
-- 					if (str == "") then
-- 						str = args[i];
-- 					else
-- 						str = str .. " " .. args[i];
-- 					end
-- 				end
-- 				Jobs.givePlayerCharge(source, args[3], str);
-- 			end
-- 		end
-- 	elseif (args[1] == "/cuff") then
-- 		CancelEvent();
-- 		if (Jobs.police.users[steamID]) then
-- 			if (not args[2] or not GetPlayerName(args[2])) then
-- 				TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4MDT: ^1Player ID is invalid.");
-- 			else
-- 				TriggerClientEvent("Jobs:cuff", args[2], true);
-- 				TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Police: ^1You have cuffed " .. GetPlayerName(args[2]));
-- 				TriggerClientEvent("chatMessage", args[2], "",{255, 255, 255}, "^4Police: ^1You have been cuffed by " .. GetPlayerName(args[2]));
-- 			end
-- 		end
-- 	elseif (args[1] == "/uncuff") then
-- 		CancelEvent();
-- 		if (Jobs.police.users[steamID]) then
-- 			if (not args[2] or not GetPlayerName(args[2])) then
-- 				TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4MDT: ^1Player ID is invalid.");
-- 			else
-- 				TriggerClientEvent("Jobs:cuff", args[2], false);
-- 				TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4Police: ^1You have uncuffed " .. GetPlayerName(args[2]));
-- 				TriggerClientEvent("chatMessage", args[2], "",{255, 255, 255}, "^4Police: ^1You have been uncuffed by " .. GetPlayerName(args[2]));
-- 			end
-- 		end
-- 	elseif (args[1] == "/jail") then
-- 		CancelEvent();
-- 		if (Jobs.police.users[steamID]) then
-- 			if (not args[2] or not GetPlayerName(args[2])) then
-- 				TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^4MDT: ^1Player ID is invalid.");
-- 			else
-- 				if (not args[3] or not args[4] or args[4] == "" or args[4] ~= Jobs.jail.password) then
-- 					sendUsage(source, "jail");
-- 				else
-- 					Jobs.jail.users[#Jobs.jail.users + 1] = {player = args[2], time = args[3]*60};
-- 					TriggerClientEvent("Jobs:jail", args[2], true, args[3]);
-- 					TriggerClientEvent("chatMessage", -1, "",{255, 255, 255}, "^4Jail: ^0" .. GetPlayerName(args[2]) .. " was sent to jail for " .. args[3] .. " minutes - by " .. GetPlayerName(source) .. ".");
-- 				end
-- 			end
-- 		end
-- 	end
-- end);

function sendUsage(sourcePlayer, usage)
	if (usage == "police") then
		TriggerClientEvent("chatMessage", sourcePlayer, "",{255, 255, 255}, "^4Usage police:");
		TriggerClientEvent("chatMessage", sourcePlayer, "",{255, 255, 255}, "/job police [tag]");
	elseif (usage == "jail") then
		TriggerClientEvent("chatMessage", sourcePlayer, "",{255, 255, 255}, "^4Usage jail:");
		TriggerClientEvent("chatMessage", sourcePlayer, "",{255, 255, 255}, "/jail [playerID] [minutes]");
	end
end

------------------------------------------------------------
-- Server: functions
------------------------------------------------------------

function Jobs.givePlayerCharge(source, player, charge)
	local source_steamID = getPlayerSteamID(source);
	local player_steamID = getPlayerSteamID(player);
	local source_charID = exports['framework']:getPlayerList()[tonumber(source_steamID)].currentCharacter.id;
	local player_charID = exports['framework']:getPlayerList()[tonumber(player_steamID)].currentCharacter.id;
	print("Officer " .. GetPlayerName(source) .. " (charID: " .. source_charID .. " ID: " .. source .. ") charged player " .. GetPlayerName(player) .. "(charID: " .. player_charID .. " ID: " .. player .. ") with: " .. charge);
	MySQL.Async.execute("INSERT INTO charges (`timestamp`, `charID`, `username`, `officer_charID`, `officer_username`, `charge`) VALUES (NOW(), @charID, @username, @officer_charID, @officer_username, @charge);",
		{["@charID"] = player_charID, ["@username"] = GetPlayerName(player), ["@officer_charID"] = source_charID, ['@officer_username'] = GetPlayerName(source), ['@charge'] = charge}, function()
		TriggerClientEvent("chatMessage", -1, "",{255, 255, 255}, "^4Charge: ^0" .. GetPlayerName(player) .. " was charged with - " .. charge .. " - by " .. GetPlayerName(source));
	end);
end

function Jobs.displayPlayerCharges(source, player)
	local source_steamID = getPlayerSteamID(source);
	local player_steamID = getPlayerSteamID(player);
	local source_charID = exports['framework']:getPlayerList()[tonumber(source_steamID)].currentCharacter.id;
	local player_charID = exports['framework']:getPlayerList()[tonumber(player_steamID)].currentCharacter.id;
	print("Officer " .. GetPlayerName(source) .. " (steamID: " .. source_charID .. " ID: " .. source .. ") has requested the charges of player " .. GetPlayerName(player) .. "(steamID: " .. player_charID .. " ID: " .. player .. ")");
	MySQL.Async.fetchAll("SELECT * FROM charges WHERE charID = @charID ORDER BY `timestamp` DESC LIMIT 20", {["@charID"] = player_charID}, function(charges)
		TriggerClientEvent("Jobs:displayCharges", source, GetPlayerName(player), charges);
		if (#charges == 0) then
			TriggerClientEvent("chatMessage", source, "",{255, 255, 255}, "^0This player has no record yet.");
		end
	end);
end


------------------------------------------------------------
-- Server: Jail functions
------------------------------------------------------------

function Jobs.jailUpdate()
	SetTimeout(60000, Jobs.jailUpdate);
	for i, user in pairs(Jobs.jail.users) do
		user.time = user.time - 60;
		if (user.time <= 0) then
			table.remove(Jobs.jail.users, i);
			TriggerClientEvent("Jobs:jail", user.player, false, user.time/60);
			TriggerClientEvent("chatMessage", -1, "",{255, 255, 255}, "^4Jail: ^0" .. GetPlayerName(user.player) .. " has been released from jail.");
		else
			TriggerClientEvent("Jobs:jail", user.player, true, user.time/60);
		end
	end
end
SetTimeout(60000, Jobs.jailUpdate);


------------------------------------------------------------
-- Server: Utils
------------------------------------------------------------

function Jobs.playerDropped(reason)
	local steamID = getPlayerSteamID(source);
	if (Jobs.police.users[steamID]) then
		Jobs.police.users[steamID] = nil;
	elseif (Jobs.fire.users[steamID]) then
		Jobs.fire.users[steamID] = nil;
	elseif (Jobs.ems.users[steamID]) then
		Jobs.fire.users[steamID] = nil;
	end
end
AddEventHandler("playerDropped", Jobs.playerDropped);

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
