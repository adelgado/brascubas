local http = require('luanode.http')
local fs   = require('luanode.fs')

local dispatcher = require './dispatcher'

local PORT = 8080

http.createServer(dispatcher):listen(PORT) 
console.log('Server running at http://127.0.0.1:' .. tostring(PORT) .. '/')

process:loop()
