fx_version 'bodacious'
games { 'rdr3', 'gta5' }

author 'whitewingz'
description 'One City Shops'
version '1.0.0'

client_script{
	'client.lua',
	'gui.lua',
	"@irp-errorlog/client/cl_errorlog.lua"
}

server_script 'server.lua'
