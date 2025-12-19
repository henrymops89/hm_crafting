fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Henry'
description 'Advanced Multi-Framework Crafting System'
version '0.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/recipes.lua'
}

client_scripts {
    'bridge/framework.lua',
    'bridge/inventory.lua',
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'bridge/framework.lua',
    'bridge/inventory.lua',
    'server/*.lua'
}

ui_page 'web/build/index.html'

files {
    'web/build/index.html',
    'web/build/**/*'
}

dependencies {
    'ox_lib',
    'oxmysql'
}
