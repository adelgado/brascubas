express  = require 'express'
stylus   = require 'stylus'

app = express()

app.use express.static(process.cwd() + '/public')
app.use express.cookieParser()
app.use express.session(
  secret: 'shhh'
  store: new express.session.MemoryStore
) 

app.set 'view engine', 'html'    # use .html extension for templates
app.enable 'view cache'
app.engine 'html', require('hogan-express')

routes = require './routes'
routes(app)

app.listen 8080, ->
  console.log "Listening on 8080"
