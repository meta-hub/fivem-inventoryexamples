fx_version 'bodacious'
game 'gta5'

client_scripts {
    '@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/client.lua'
}

server_scripts {
    '@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'locales/en.lua',
	'config.lua',
	'server/server.lua'
}

dependencies {
	'es_extended',
	'mf-inventory',
	'fivem-safecracker'
}