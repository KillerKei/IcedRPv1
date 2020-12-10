fx_version 'adamant'
games { 'gta5' }

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@irp-core/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@irp-core/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua',
	"@irp-errorlog/client/cl_errorlog.lua"
}

dependencies {
	'irp-core',
	'cron',
	'irp-addonaccount'
}
