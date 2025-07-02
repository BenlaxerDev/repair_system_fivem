fx_version 'cerulean'
game 'gta5'

author 'AvocatoDev'
description 'Advanced Vehicle Repair System'
version '1.0.0'

shared_scripts {
    'config.lua',
    'locales/*.lua',
    'debug.lua',
    'progress.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'es_extended',
    'qb-core',
    'ox_lib'
}

lua54 'yes' 