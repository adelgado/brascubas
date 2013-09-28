module.exports = (app) ->

  app.all '/', (req, res) ->
    res.render 'index'
