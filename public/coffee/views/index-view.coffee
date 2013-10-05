define [
  'chaplin'
  'views/base/view'
  'text!templates/index.hbs'
  'models/room'
], (
  Chaplin
  View
  template
  Room
) ->
  'use strict'

  class IndexView extends View
    # Automatically render after initialize.
    autoRender: true
    className: 'index'

    # Save the template string in a prototype property.
    # This is overwritten with the compiled template function.
    # In the end you might want to used precompiled templates.
    template: template
    template = null

    events:
      'click button' : 'handleButtonClick'

    handleButtonClick: ->
      room = new Room
      room.save {}, success: (room, response) ->
        Chaplin.helpers.redirectTo 'room#show', id: room.get('id')

