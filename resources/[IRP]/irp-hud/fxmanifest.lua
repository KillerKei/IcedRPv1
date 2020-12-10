fx_version 'adamant'
games { 'gta5' }

client_script 'carhud.lua'
client_script "@irp-errorlog/client/cl_errorlog.lua"

ui_page('html/index.html')

files({
	"html/index.html",
	"html/script.js",
	"html/styles.css",
	"html/img/*.svg",
	"html/img/*.png"
})

exports {
	"playerLocation",
	"playerZone"
}
