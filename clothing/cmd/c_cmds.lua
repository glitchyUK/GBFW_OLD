addCLCommand("skin", "/skin change", {}, function(src,args)
	local action = args[1];
	if (action == "change") then
		Clothing.display(true, "civ");
	elseif (action == "police" and exports.framework:myAccount().currentCharacter.job == "police") then
		Clothing.display(true, "cop");
	end
end);