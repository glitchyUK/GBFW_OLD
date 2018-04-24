resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"
resource_type "gametype" { name = "GlitchyBoi" }

function shared_script(file)
	client_script(file)
	server_script(file)
end

server_script '@mysql-async/lib/MySQL.lua'

client_script "c_spawn.lua"
client_script "c_utils.lua"
client_script "c_main.lua"
server_script "s_main.lua"

client_script "account/c_account.lua"
server_script "account/s_account.lua"

client_script "lobby/c_lobby.lua"

shared_script "cmd/sh_cmds.lua"
client_script "cmd/c_cmds.lua"
server_script "cmd/s_cmds.lua"

export "getPlayerSteamID"
export "myAccount"
server_export 'getPlayerList'
