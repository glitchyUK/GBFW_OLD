------------------------------------------------------------
------------------------------------------------------------
---- Author: Dylan 'Itokoyamato' Thuillier              ----
----                                                    ----
---- Email: itokoyamato@hotmail.fr                      ----
------------------------------------------------------------
------------------------------------------------------------
addCLCommand("police", "/police spawn [vehicle]", {}, function(src,args)
	if (Jobs.myJob ~= "police") then
		return;
	end

	local action = args[1];
	if (action == "spawn") then
		local vehicleName = args[2];
		if (not args[2]) then
			TriggerEvent("chat:addMessage", {color={255,255,255},args={"Usage: /police spawn [vehicleName]"}});
			return;
		end
		local myAccount = exports.framework:myAccount();
		for i, station in pairs(Police.stations) do
			if (myAccount and myAccount.currentCharacter and myAccount.currentCharacter.job == "police") then
				local garageDistance = GetDistanceBetweenCoords(station.garage.x, station.garage.y, station.garage.z, GetEntityCoords(GetPlayerPed(-1)), true);

				if (garageDistance < 2) then
					for i, vehicle in pairs(station.vehicles) do
						if (vehicle.name == vehicleName) then
							Citizen.CreateThread(function()
								local Hash = GetHashKey(vehicle.hash, _r);

								RequestModel(Hash);
								while not HasModelLoaded(Hash) do
									Wait(5);
								end

								if not IsAnyVehicleNearPoint(station.garage.x, station.garage.y, station.garage.z, 2.0) then

									vehicle = CreateVehicle(Hash, station.garage.x, station.garage.y, station.garage.z, station.garage.heading, true, false);
									SetEntityAsMissionEntity(vehicle);
								else
									TriggerEvent("chat:addMessage", {color={255,255,255},args={"A vehicle is blocking the area."}});
								end
							end);
							break;
						end
					end
				end
			end
		end
	end
end);
