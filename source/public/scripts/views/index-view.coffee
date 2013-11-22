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
    PEER_KEY: 'e5gaw8eew1ocrf6r'

    autoRender: true
    
    className: 'room'

    # Save the template string in a prototype property.
    # This is overwritten with the compiled template function.
    # In the end you might want to used precompiled templates.
    template: template
    template = null

    events:
      'click #connect' : 'connect'
      'click #send'    : 'send'

    render: ->
      super

      @$conversation = @$('.conversation')
      @$conversation.fadeOut()

    attach: ->
      super

      @initPeer()

    initPeer: ->
      @peer = new Peer key: @PEER_KEY

      @peer.on 'open', (id) ->
        console.log "Peer open with id #{id}"

      @peer.on 'connection', (conn) ->
        conn.on 'data', (data, a) ->
          console.log a
          console.log(data)

    connect: ->
      @$conversation.fadeIn 'slow'

      peerId = prompt('What peer would you like to connect to?')

      conn = @peer.connect peerId

      conn.on 'open', =>
        @connection = conn

    send: ->
      return console.log 'No connection!' unless @connection?

      message = @$('#client').val()
      @connection.send message
