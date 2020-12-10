fx_version 'adamant'

game 'gta5'

description 'ESX DMV School'

version '1.0.4'

server_scripts {
	'@irp-core/locale.lua',
	'locales/br.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/en.lua',
	'locales/pl.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@irp-core/locale.lua',
	'locales/br.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/en.lua',
	'locales/pl.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua',
	"@irp-errorlog/client/cl_errorlog.lua"
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/logo.png',
	'html/dmv.png',
	'html/styles.css',
	'html/questions.js',
	'html/scripts.js',
	'html/debounce.min.js'
}

dependencies {
	'irp-core',
	'irp-license'
}
