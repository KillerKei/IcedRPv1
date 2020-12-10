server_scripts {
    '@irp-core/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@irp-core/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',
	"@irp-errorlog/client/cl_errorlog.lua"
}

fx_version 'adamant'
games { 'gta5' }