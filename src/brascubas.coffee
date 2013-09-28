express  = require 'express'
stylus   = require 'stylus'
assets   = require 'connect-assets'

app = express()

app.port = process.env.PORT or process.env.VMC_APP_PORT or 3000

# Config module exports has `setEnvironment` function that sets app settings depending on environment.
config = require "./config"
app.configure 'production', 'development', 'testing', ->
  config.setEnvironment app.settings.env


app.use assets()
app.use express.static(process.cwd() + '/public')
# Express Session
store = new express.session.MemoryStore
app.use express.cookieParser()
app.use express.session(
  secret: 'shhh'
  store: store
) 

app.set 'view engine', 'html'    # use .html extension for templates
app.enable 'view cache'
app.engine 'html', require('hogan-express')


# [Body parser middleware](http://www.senchalabs.org/connect/middleware-bodyParser.html) parses JSON or XML bodies into `req.body` object
app.use express.bodyParser()

#### Finalization
# Initialize routes
routes = require './routes'
routes(app)

module.exports = app
