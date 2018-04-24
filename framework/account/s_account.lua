------------------------------------------------------------
------------------------------------------------------------
---- Author: Dylan 'Itokoyamato' Thuillier              ----
----                                                    ----
---- Email: itokoyamato@hotmail.fr                      ----
------------------------------------------------------------
------------------------------------------------------------
Account = {};
Account.__index = Account;

function Account.createNewCharacter(firstname, lastname)
	local source = source;
	Citizen.CreateThread(function()
		steamid = tonumber(GetPlayerIdentifiers(source)[1]:gsub("steam:", ""), 16);
		MySQL.Async.execute("" .. 
			"INSERT INTO characters (`steamid`, `firstname`, `lastname`, `inventory`, `weapons`)" ..
			"SELECT DISTINCT '" .. steamid .. "', '" .. firstname .. "', '" .. lastname .. "', '{}', '{}'" .. 
			"WHERE (SELECT COUNT(*) FROM characters WHERE steamid = '" .. steamid .. "' ) < 5;", {}, function()
				TriggerClientEvent("onClientPlayerReady", source);
		end);
	end);
end
RegisterServerEvent("Account:createNewCharacter");
AddEventHandler("Account:createNewCharacter", Account.createNewCharacter);

function Account.login()
	local steamid = tonumber(GetPlayerIdentifiers(source)[1]:gsub("steam:", ""), 16);
	local sourcePlayer = source;
	local account = setmetatable({loaded = false}, Account);
	Citizen.CreateThread(function()
		MySQL.Async.fetchAll("SELECT * FROM users WHERE steamid = "..steamid.."", {}, function(result)
			if (result[1] ~= nil) then
				if result[1].banned then
					print('Player that was banned tried to join: ' .. steamid);
					DropPlayer(sourcePlayer, "You are banned.");
					CancelEvent();
					return false;
				end

				account.steamid = steamid;
				account.banned = result[1].banned;
				account.admin_rank = result[1].admin_rank;
				local characters_query = MySQL.Async.fetchAll("SELECT * FROM characters WHERE steamid = '"..steamid.."'", {}, function(characters)
					account.characters = characters;
					account.isLoggedIn = 0;
					account.currentCharacter = false;
					account.loaded = true;
					account.admin_rank = account.admin_rank;
				end);
			else
				local username = GetPlayerName(sourcePlayer);
				if (not username) then
					print("couldnt retrieve username for id " .. tostring(sourcePlayer));
					return (false);
				end
				MySQL.Async.execute("INSERT INTO users (`steamid`, `username`) VALUES ("..steamid..", '"..username.."')", {}, function()
					account.steamid = steamid;
					account.banned = 0;
					account.bank = 0;
					account.admin_rank = 0;
					account.isLoggedIn = 0;
					account.currentCharacter = false;
					account.loaded = true;
				end);
			end
		end);
		local delay = 0;
		while (not account.loaded) do
			Wait(100);
			delay = delay + 100;
			if (delay >= 10000) then
				return (false)
			end
		end
		TriggerClientEvent("onClientPlayerLogin", -1, account);
		account.netID = sourcePlayer;
		playerList[steamid] = account;
	end);
end
RegisterServerEvent("Account:login");
AddEventHandler("Account:login", Account.login);

function Account.selectCharacter(charID)
	local steamid = tonumber(GetPlayerIdentifiers(source)[1]:gsub("steam:", ""), 16);
	for i, row in ipairs(playerList[steamid].characters) do
		if (row.id == tonumber(charID)) then
			playerList[steamid].currentCharacter = row;
			playerList[steamid].currentCharacter.weapons = load("return " .. playerList[steamid].currentCharacter.weapons)();
			TriggerClientEvent("Account:loadCharacter", source, row);
			return;
		end
	end
end
RegisterServerEvent("Account:selectCharacter");
AddEventHandler("Account:selectCharacter", Account.selectCharacter);

function Account.updateData(pos, heading, weapons)
	local steamid = tonumber(GetPlayerIdentifiers(source)[1]:gsub("steam:", ""), 16);
	playerList[steamid].currentCharacter.pos_x = ensureFloat(pos.x);
	playerList[steamid].currentCharacter.pos_y = ensureFloat(pos.y);
	playerList[steamid].currentCharacter.pos_z = ensureFloat(pos.z);
	playerList[steamid].currentCharacter.heading = heading;
	playerList[steamid].currentCharacter.weapons = weapons;
end
RegisterServerEvent("Account:updateData");
AddEventHandler("Account:updateData", Account.updateData);

function Account.updateModel(modelName)
	local steamid = tonumber(GetPlayerIdentifiers(source)[1]:gsub("steam:", ""), 16);
	playerList[steamid].currentCharacter.modelName = modelName;
end
RegisterServerEvent("Account:updateModel");
AddEventHandler("Account:updateModel", Account.updateModel);

function Account.save(account)
	local c = account.currentCharacter;
	Citizen.CreateThread(function()
		MySQL.Async.execute("UPDATE characters SET money = " .. tonumber(c.money) .. ", pos_x = " .. c.pos_x .. ", pos_y = " .. c.pos_y .. ", pos_z = " .. c.pos_z .. ", heading = " .. c.heading .. ", weapons = '" .. table.tostring(c.weapons) .. "', modelName = '" .. c.modelName .. "' WHERE id = " .. c.id, {}, function()
			print("Saved account " .. account.steamid);
		end);
	end);
end
