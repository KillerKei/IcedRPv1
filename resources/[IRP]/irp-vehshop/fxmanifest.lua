fx_version 'adamant'
games { 'gta5' }

ui_page 'html/index.html'

server_scripts {
	'@irp-core/locale.lua',
	'locales/en.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/server.lua'
}

client_scripts {
	'@irp-core/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/client.lua',
	'client/utils.lua'
}

files {
	'html/index.html',
	'html/assets/css/*.css',
	'html/assets/js/*.js',
	'html/assets/images/*.png'
}
