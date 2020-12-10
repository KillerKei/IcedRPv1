fx_version 'adamant'
games { 'gta5' }

client_scripts {
  'config.lua',
  'client.lua',
  "@irp-errorlog/client/cl_errorlog.lua"
}

server_scripts {	
  '@mysql-async/lib/MySQL.lua',
  'config.lua',
	'server.lua',
}