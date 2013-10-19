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

    hasGetUserMedia: ->
      # Note: Opera is unprefixed.
      return !!(navigator.getUserMedia || navigator.webkitGetUserMedia ||
                navigator.mozGetUserMedia || navigator.msGetUserMedia)

    getUserMedia: ->
      navigator.getUserMedia || navigator.webkitGetUserMedia ||
      navigator.mozGetUserMedia || navigator.msGetUserMedia
      
    attach: ->
      super

      setTimeout cam.video ($video) ->
        if $video?
          console.log 'its alive'
          $('#local-camera-container').appendChild $video
        else
          console.log 'houston, we have a problem'
      , 1000

    #   if @hasGetUserMedia()
    #     console.log 'good to go'

    #     permissions =
    #       video: true
    #       audio: true

    #     @getUserMedia permissions, @onPermissionGranted, @onPermissionDenied
    #   else
    #     alert 'getUserMedia() is not supported in your browser'

    # onPermissionGranted: (localMediaStream) ->
    #   video = $('video') #document.querySelector('video')
    #   video.src = window.URL.createObjectURL(localMediaStream)

    #   # Note: onloadedmetadata doesn't fire in Chrome when using it with getUserMedia.
    #   # See crbug.com/110938.
    #   video.onloadedmetadata = (e) ->
    #     console.log " Ready to go. Do some stuff."

    # onPermissionDenied: (e) ->
    #   console.log('Reeeejected!', e)

