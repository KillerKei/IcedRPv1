server_scripts {
    '@irp-core/locale.lua',
	'locales/de.lua',
	'locales/en.lua',
    'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@irp-core/locale.lua',
	'locales/de.lua',
	'locales/en.lua',
    'locales/fr.lua',
	'config.lua',
	'client/main.lua',
	"@irp-errorlog/client/cl_errorlog.lua"
}

fx_version 'adamant'
games { 'gta5' }