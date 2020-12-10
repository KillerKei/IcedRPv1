fx_version 'adamant'
games { 'gta5' }
client_script "@irp-errorlog/client/cl_errorlog.lua"
server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}
