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
	local adminrank = tonumber(exports['framework']:getPlayerList()[tonumber(getPlayerSteamID(src))].admin_rank);
	TriggerClientEvent('chatMessage', adminrank, "", {0, 0, 0}, "^8Incorrect Player ID!")
	return "^3(INFO) Kick issued for [ " .. target .. " | " .. GetPlayerName(target) .. " ] by [ " .. src .. " | " .. GetPlayerName(src) .. " ]"
end,1) -- Admin level
