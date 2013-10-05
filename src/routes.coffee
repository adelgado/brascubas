module.exports = (app) ->

  app.all '/', (req, res) ->
    res.render 'index'

  app.post '/room', (req, res) ->
  	id = Math.floor(Math.random() * 1000)

  	res.json(201, id: id)
