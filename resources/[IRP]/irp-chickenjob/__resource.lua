resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'


client_scripts {
  '@irp-core/locale.lua',
  'locales/en.lua',
  'client/chicken_c.lua',
  "@irp-errorlog/client/cl_errorlog.lua"
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  '@irp-core/locale.lua',
  'locales/en.lua',
  'server/chicken_s.lua',
}

dependencies {
	'irp-core'
}