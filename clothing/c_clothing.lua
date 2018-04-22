Clothing = setmetatable({}, Clothing);
Clothing.__index = Clothing;

Clothing.active = false;
Clothing.currentList = "civ";
Clothing.current = 1;

Clothing.saveSkin = false;
Clothing.lastChange = 0;

Citizen.CreateThread(function()
	while true do
		Wait(1);
		if (Clothing.active) then
			drawTxt("Current skin: " .. skins[Clothing.currentList][Clothing.current] .. " [" .. Clothing.current .. "/" .. #skins[Clothing.currentList] .. "]",0,1,0.5,0.76,0.6,255,255,255,255);
			drawTxt("Hold [~r~C~s~] to look at yourself",0,1,0.5,0.8,0.6,255,255,255,255);
			drawTxt("Press [~r~page-up~s~] or [~r~page-down~s~] to change skin",0,1,0.5,0.84,0.6,255,255,255,255);
			drawTxt("Press [~r~enter~s~] to save your skin",0,1,0.5,0.88,0.6,255,255,255,255);
			drawTxt("Press [~r~del~s~] to cancel",0,1,0.5,0.92,0.6,255,255,255,255);
			if (IsControlJustPressed(1, 10)) then
				Clothing.current = Clothing.current + 1;
				if (Clothing.current > #skins[Clothing.currentList]) then Clothing.current = 1 end;
				Clothing.change(skins[Clothing.currentList][Clothing.current]);
			end
			if (IsControlJustPressed(1, 11)) then
				Clothing.current = Clothing.current - 1;
				if (Clothing.current < 1) then Clothing.current = #skins[Clothing.currentList] end;
				Clothing.change(skins[Clothing.currentList][Clothing.current]);
			end
			if (IsControlJustPressed(0, 178)) then
				Clothing.cancel();
			end
			if (IsControlJustPressed(0, 18)) then
				Clothing.save();
			end
		end
	end
end);

function Clothing.change(hash)
	Citizen.CreateThread(function()
		local modelhashed = GetHashKey(hash);
		RequestModel(modelhashed);
		while not HasModelLoaded(modelhashed) do
			RequestModel(modelhashed);
			Wait(5);
		end
		SetPlayerModel(PlayerId(), modelhashed);
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0.05);
		SetPedMaxHealth(GetPlayerPed(-1), 275);
	end);
end

function Clothing.display(state, category)
	if (state and GetGameTimer() - Clothing.lastChange < 600000) then
		TriggerEvent("chat:addMessage", {color={255,255,255},args={"You can only change skin every 10 minutes."}});
		return;
	end
	Clothing.active = state;
	Clothing.currentList = category;
	Clothing.current = 1;
	if (state) then
		Clothing.saveSkin = GetEntityModel(GetPlayerPed(-1));
	end
end

function Clothing.save()
	TriggerServerEvent("Account:updateModel", skins[Clothing.currentList][Clothing.current]);
	Clothing.display(false, "civ");
	Clothing.lastChange = GetGameTimer();
end

function Clothing.cancel()
	Citizen.CreateThread(function()
		while not HasModelLoaded(Clothing.saveSkin) do
			RequestModel(Clothing.saveSkin);
			Wait(5);
		end
		SetPlayerModel(PlayerId(), Clothing.saveSkin);
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0.05);
		SetPedMaxHealth(GetPlayerPed(-1), 275);
		Clothing.display(false, "civ");
	end);
end

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
