fx_version 'adamant'

game 'gta5'

client_script "@irp-errorlog/client/cl_errorlog.lua"
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/classes/datastore.lua',
	'server/main.lua'
}
