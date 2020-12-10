resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Police Job'

version '1.3.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
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
	'client/client_trunk.lua',
	"@irp-errorlog/client/cl_errorlog.lua"
	--'client/evidence.lua',
	
}

dependencies {
	'irp-core'
}