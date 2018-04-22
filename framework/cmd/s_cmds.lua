addCommand("kick","",{
	{"PlayerID"},{"[Reason]","Optional"}
},function(src,args)
	local target = tonumber(args[1])
	if not target then
		return "No player or invalid player specified"
	end

	DropPlayer(target,args[2] or "You got kicked.")
end,1) -- Admin level
