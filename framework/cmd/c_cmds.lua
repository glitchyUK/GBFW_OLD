addCLCommand("pos","Print your position",{
},function(src,args)
	local pos = GetEntityCoords(GetPlayerPed(-1))
	local heading = GetEntityHeading(GetPlayerPed(-1))
	TriggerEvent("chat:addMessage",{
		color={255,255,255},args={"Pos",tostring(pos) .. " " .. tostring(heading)}
	})
end)

addCLCommand("char", "/char select [charID] | /char create [firstname] [lastname] | /char delect [charID]", {}, function(src,args)
	if (not Account.me.isLoggedIn) then
		TriggerEvent("chat:addMessage", {color={255,255,255},args={"You are not logged in yet."}});
		return;
	end
	if (Account.me.currentCharacter) then
		TriggerEvent("chat:addMessage", {color={255,255,255},args={"You already selected your character."}});
		return;
	end

	local action = args[1];
	if (action == "select") then
		Citizen.Trace("hi");
		local charID = args[2];
		if (not args[2]) then
			TriggerEvent("chat:addMessage", {color={255,255,255},args={"Usage: /char select [charID]"}});
			return;
		end
		for i, row in ipairs(Account.me.characters) do
			if (row.id == tonumber(charID)) then
				Citizen.Trace("success");
				TriggerServerEvent("Account:selectCharacter", charID);
			end
		end
	elseif (action == "create") then
		local firstname = args[2];
		local lastname = args[3];
		if (not args[2] or not args[3]) then
			TriggerEvent("chat:addMessage", {color={255,255,255},args={"Usage: /char create [firstname] [lastname]"}});
			return;
		end
		if (#Account.me.characters >= 5) then
			TriggerEvent("chat:addMessage", {color={255,255,255},args={"You already have too many characters."}});
			return;
		end
		TriggerServerEvent("Account:createNewCharacter", firstname, lastname);
	end
end);