-- General Resources
resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"
resource_type "gametype" { name = "JCRP" }

function shared_script(file)
	client_script(file)
	server_script(file)
end

server_script '@mysql-async/lib/MySQL.lua'

shared_script "cmd/sh_cmds.lua"
client_script "cmd/c_cmds.lua"
server_script "cmd/s_cmds.lua"

-- Main Framework
client_script "framework/c_spawn.lua"
client_script "framework/c_utils.lua"
client_script "framework/c_main.lua"
server_script "framework/s_main.lua"

client_script "framework/account/c_account.lua"
server_script "framework/account/s_account.lua"

client_script "framework/lobby/c_lobby.lua"

-- Admin
client_script "admin/c_admin.lua"
server_script "admin/s_admin.lua"

-- Clothing
client_script "c_clothing.lua"
client_script "skins.lua"

-- Jobs
client_script "c_job.lua"
server_script "s_job.lua"

-- Exports
export "getPlayerSteamID"
export "myAccount"
server_export 'getPlayerList'
