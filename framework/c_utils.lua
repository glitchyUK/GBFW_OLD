RegisterNetEvent("AwesomeFreeze")
RegisterNetEvent("AwesomeInvisible")
RegisterNetEvent("AwesomeGod")
RegisterNetEvent("spawnWeaponForPlayer")
RegisterNetEvent("AwesomeSetWanted")

function setPlayerWanted(level)
	SetPlayerWantedLevel(PlayerId(), level, false)
	SetPlayerWantedLevelNow(PlayerId(), false)
end
AddEventHandler('AwesomeSetWanted', setPlayerWanted);

function setPlayerFrozen(freeze)
    Citizen.CreateThread(function()
		Citizen.Wait(500)
		local ped = GetPlayerPed(-1)

		if not freeze then
			FreezeEntityPosition(ped, false)
			SetPlayerControl(ped, true, true)
		else
			FreezeEntityPosition(ped, true)
			SetPlayerControl(ped, false, false)
			if not IsPedFatallyInjured(ped) then
				ClearPedTasksImmediately(ped)
			end
		end
    end)
end
AddEventHandler("AwesomeFreeze", setPlayerFrozen);

function setPlayerGod(godmode)
    Citizen.CreateThread(function()
		Citizen.Wait(500)
		local ped = GetPlayerPed(-1)

		if not godmode then
			SetEntityInvincible(GetPlayerPed(-1), false)
		else
			SetEntityInvincible(GetPlayerPed(-1), true)
			outputChatBox("[GOD]", "^0 God Mode Enabled", { 0, 153, 204}, {0, 153, 204});
		end
    end)
end
AddEventHandler("AwesomeGod", setPlayerGod);

function givePlayerWeapon(weapon)
	Citizen.CreateThread(function()
        Citizen.Wait(50)
        local weaponid = GetHashKey(weapon)
        local playerPed = GetPlayerPed(-1)
        if playerPed and playerPed ~= -1 then
			outputChatBox("[SYSTEM]", "^0 🔫 Weapon spawned for: ^2💲400", { 0, 153, 204}, {0, 153, 204});
			GiveWeaponToPed(playerPed, weaponid, 500, true, true)			
        end
    end)
end
AddEventHandler("spawnWeaponForPlayer", givePlayerWeapon);

function setPlayerInvisible(invisible)
    Citizen.CreateThread(function()
		Citizen.Wait(500)
		local ped = GetPlayerPed(-1)

		if not invisible then
			if not IsEntityVisible(ped) then
				SetEntityVisible(ped, true)
			end

			if not IsPedInAnyVehicle(ped) then
				SetEntityCollision(ped, true)
			end
			
			--SetCharNeverTargetted(ped, false)
			SetPlayerInvincible(player, false)
		else
			if IsEntityVisible(ped) then
				SetEntityVisible(ped, false)
			end

			SetEntityCollision(ped, false)
			--SetCharNeverTargetted(ped, true)
			SetPlayerInvincible(player, true)
			--RemovePtfxFromPed(ped)

			if not IsPedFatallyInjured(ped) then
				ClearPedTasksImmediately(ped)
			end
		end
    end)
end
AddEventHandler("AwesomeInvisible", setPlayerInvisible);

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)	
end

function ensureFloat(number)
	if math.modf(number) == 0 then
		return number + .0001
	end
	
	return number		
end

--------------------------------------------------------------------------------
--	Utils: Table functions
--------------------------------------------------------------------------------

function table.val_to_str (v)
	if ("string" == type(v)) then
		v = string.gsub(v, "\n", "\\n");
		if (string.match(string.gsub(v, "[^'\"]", ""), '^"+$')) then
			return ("'"..v.."'");
		end
		return ('"'..string.gsub(v, '"', '\\"')..'"');
	else
		return ("table" == type(v) and table.tostring(v) or tostring(v));
	end
end

function table.key_to_str (k)
	if ("string" == type(k) and string.match(k, "^[_%a][_%a%d]*$")) then
		return (k);
	else
		return ("["..table.val_to_str(k).."]");
	end
end

function table.tostring(tbl)
	local result, done = {}, {};
	for k, v in ipairs(tbl) do
		table.insert(result, table.val_to_str(v));
		done[k] = true;
	end
	for k, v in pairs(tbl) do
		if (not done[k]) then
			table.insert(result, table.key_to_str(k).."="..table.val_to_str(v));
		end
	end
	return ("{"..table.concat(result, ",").."}");
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end