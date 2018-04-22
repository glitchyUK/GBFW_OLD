------------------------------------------------------------
------------------------------------------------------------
---- Author: Dylan 'Itokoyamato' Thuillier              ----
----                                                    ----
---- Email: itokoyamato@hotmail.fr                      ----
------------------------------------------------------------
------------------------------------------------------------

resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

function shared_script(file)
	client_script(file)
	server_script(file)
end

server_script "@mysql-async/lib/MySQL.lua"

shared_script "cmd/sh_cmds.lua"
client_script "cmd/c_cmds.lua"
server_script "cmd/s_cmds.lua"

client_script "c_job.lua"
server_script "s_job.lua"

-- client_script "c_admin.lua"
-- server_script "s_admin.lua"

-- client_script "c_clothing.lua"
-- client_script "skins.lua"
