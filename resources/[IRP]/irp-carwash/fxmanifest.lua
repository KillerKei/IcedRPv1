fx_version 'adamant'
games { 'gta5' }

server_scripts {
	'@irp-core/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@irp-core/locale.lua',
	'locales/en.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua',
	"@irp-errorlog/client/cl_errorlog.lua"
}

dependency 'irp-core'