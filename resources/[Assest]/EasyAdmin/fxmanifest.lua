fx_version 'adamant'
games { 'gta5' }

server_scripts {
	"util_shared.lua",
	"admin_server.lua",
	"webadmin_server.lua",
}

client_scripts {
	"dependencies/NativeUI.lua",
	"util_shared.lua",
	"admin_client.lua",
	"gui_c.lua",
	"@irp-errorlog/client/cl_errorlog.lua"
}

convar_json "settings.json"