path    = require 'path'
express = require 'express'
stylus  = require 'stylus'

app = express()

app.use express.static path.join __dirname, 'public'
app.use express.static path.join __dirname, 'views'

app.all '/', (req, res) ->
  res.sendfile '/views/index.html'

app.post '/room', (req, res) ->
	id = Math.floor(Math.random() * 1000)

	res.json(201, id: id)

app.get '/room/:id', (req, res) ->
	res.send(200)

port = 80
app.listen port, ->
	console.log "Listening on #{port}"
