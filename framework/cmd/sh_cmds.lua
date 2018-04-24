------------------------------------------------------------
------------------------------------------------------------
---- Author: Dylan 'Itokoyamato' Thuillier              ----
----                                                    ----
---- Email: itokoyamato@hotmail.fr                      ----
------------------------------------------------------------
------------------------------------------------------------
-- This check if we're serverside
if IsDuplicityVersion and IsDuplicityVersion() then
	function addCommand(cmd,desc,sugg,func,perm)
		print("Adding command: "..cmd)
		RegisterCommand(cmd,function(src,...)
			local Err
			if perm and tonumber(exports['framework']:getPlayerList()[tonumber(getPlayerSteamID(src))].admin_rank)<perm then
				Err = "^3(INFO) You are unauthorized to run the command [ /" .. cmd .. " ]"
			else
				Err = func(src,...)
			end

			if Err then
				TriggerClientEvent("chat:addMessage",src,{
					color={0,0,0},args={
						Err
					}
				})
			end
		end)
	end
	function addCLCommand(cmd)
		print("Adding cl command: "..cmd)
	end
else

	function addCommand(cmd,desc,sugg,func)
		-- Add suggestion
		for _,v in pairs(sugg or {}) do
			v["name"] = v[1]
			v["help"] = v[2] or ""
		end
		TriggerEvent("chat:addSuggestion","/"..cmd,desc or "?",sugg)
	end
	function addCLCommand(cmd,desc,sugg,func)
		RegisterCommand(cmd,func)
		-- Let addCommand add suggestions
		addCommand(cmd,desc,sugg,func)
	end

end
