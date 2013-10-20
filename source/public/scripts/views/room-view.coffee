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

      `navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;

      var constraints = {video: true};

      function successCallback(localMediaStream) {
        window.stream = localMediaStream; // stream available to console
        var video = document.querySelector("video");
        video.src = window.URL.createObjectURL(localMediaStream);
        video.play();
      }

      function errorCallback(error){
        console.log("navigator.getUse Media error: ", error);
      }

      navigator.getUserMedia(constraints, successCallback, errorCallback);`
  
