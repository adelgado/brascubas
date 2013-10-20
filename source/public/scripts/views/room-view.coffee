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

    events:
      'click #connect' : 'connect'
     
    attach: ->
      super

      @peer = new Peer key: @PEER_KEY

      @peer.on 'open', (id) ->
        console.log "My peer ID is: #{id}"

      @peer.on 'connection', (conn) ->
        conn.on 'data', (data) ->
          console.log(data);

    connect: ->
      peerId = prompt('What peer would you like to connect to?')

      conn = @peer.connect peerId

      conn.on 'open', ->
        conn.send 'hi!'
