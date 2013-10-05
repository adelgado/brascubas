define [
  'chaplin'
  'views/base/view'
  'text!templates/room.hbs'
  'models/room'
], (
  Chaplin
  View
  template
  Room
) ->
  'use strict'

  class RoomView extends View
    # Automatically render after initialize.
    autoRender: true
    className: 'room'

    # Save the template string in a prototype property.
    # This is overwritten with the compiled template function.
    # In the end you might want to used precompiled templates.
    template: template
    template = null
