fx_version 'adamant'
games { 'gta5' }

client_script {
    "client.lua",
    "config.lua",
    "@irp-errorlog/client/cl_errorlog.lua"
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    "server.lua",
    "config.lua"
}

