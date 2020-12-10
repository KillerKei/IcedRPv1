fx_version 'adamant'
games { 'gta5' }

client_script 'client/main.lua'
client_script "@irp-errorlog/client/cl_errorlog.lua"
server_script 'server/main.lua'

ui_page('client/html/index.html')

files {
    'client/html/index.html',
    'client/html/sounds/*.ogg',
}
