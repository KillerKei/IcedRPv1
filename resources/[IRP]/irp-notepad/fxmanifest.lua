fx_version 'adamant'
games { 'gta5' }

server_scripts {
    "server/main.lua",
}

client_scripts {
    "client/main.lua",
    "@irp-errorlog/client/cl_errorlog.lua"
}

ui_page {
    'html/ui.html',
}
files {
    'html/ui.html',
    'html/css/main.css',
    'html/js/app.js',
}
