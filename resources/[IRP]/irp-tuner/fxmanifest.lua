fx_version 'adamant'
games { 'gta5' }

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/tabletbg.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

client_script 'client.lua'
client_script "@irp-errorlog/client/cl_errorlog.lua"
server_script 'server.lua'
