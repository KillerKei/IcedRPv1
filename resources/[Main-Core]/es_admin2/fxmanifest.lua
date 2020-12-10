fx_version 'adamant'
games { 'gta5' }

client_script 'client.lua'
client_script "@irp-errorlog/client/cl_errorlog.lua"
server_script 'server.lua'

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/style.css'
}

dependency 'irp-base'