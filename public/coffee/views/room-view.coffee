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

    getTemplateData: ->
      debugger
      camera.init
        targetCanvas: $('#local-camera')

        onFrame: (canvas) ->
          debugger
            # do something with image data found in the canvas argument
        onSuccess: ->
          console.log 'success'
            # stream succesfully started, yay!
        onError: (error) ->
          console.log error
            #/ something went wrong on initialization
        onNotSupported: ->
          console.log 'not supo'
            #/ instruct the user to get a better browser
        # width: 160, // default: 640
        # height: 120, // default: 480
        # fps: 30, // default: 30
        # mirror: true,  // default: false
