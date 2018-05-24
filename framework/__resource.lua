------------------------------------------------------------
------------------------------------------------------------
---- Author: Dylan 'Itokoyamato' Thuillier              ----
----                                                    ----
---- Email: itokoyamato@hotmail.fr                      ----
------------------------------------------------------------
------------------------------------------------------------

--- Main Stuff
resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"
resource_type "gametype" { name = "GBFW" }

function shared_script(file)
	client_script(file)
	server_script(file)
end

server_script '@mysql-async/lib/MySQL.lua'

--- Framework
client_script "c_spawn.lua"
client_script "c_utils.lua"
client_script "c_main.lua"
server_script "s_main.lua"

client_script "account/c_account.lua"
server_script "account/s_account.lua"

client_script "lobby/c_lobby.lua"

--- Admin
client_script "admin/c_admin.lua"
server_script "admin/s_admin.lua"

--- Jobs
client_script "jobs/c_job.lua"
server_script "jobs/s_job.lua"

--- Clothing
client_script "clothing/c_clothing.lua"
client_script "clothing/skins.lua"

--- Other
shared_script "cmd/sh_cmds.lua"
client_script "cmd/c_cmds.lua"
server_script "cmd/s_cmds.lua"

export "getPlayerSteamID"
export "myAccount"
server_export 'getPlayerList'
