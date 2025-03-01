------------------------------------------------------------
------------------------------------------------------------
---- Author: Dylan 'Itokoyamato' Thuillier              ----
----                                                    ----
---- Email: itokoyamato@hotmail.fr                      ----
------------------------------------------------------------
------------------------------------------------------------
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
		TriggerEvent("chat:addMessage", {color={255,255,255},args={"^3(INFO) You are not logged in yet"}});
		return;
	end
	if (Account.me.currentCharacter) then
		TriggerEvent("chat:addMessage", {color={255,255,255},args={"^3(INFO) You are already logged in"}});
		return;
	end

	local action = args[1];
	if (action == "select") then
		Citizen.Trace("hi");
		local charID = args[2];
		if (not args[2]) then
			TriggerEvent("chat:addMessage", {color={255,255,255},args={"^3(INFO) Invalid Usage! /char select [CharacterID]"}});
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
			TriggerEvent("chat:addMessage", {color={255,255,255},args={"^3(INFO) Invalid Usage! /char create [FirstName] [LastName]"}});
			return;
		end
		if (#Account.me.characters >= 5) then
			TriggerEvent("chat:addMessage", {color={255,255,255},args={"^3(INFO) You have reached the max amount of characters"}});
			return;
		end
		TriggerServerEvent("Account:createNewCharacter", firstname, lastname);
	end
end);