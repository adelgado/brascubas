$ ->
	PEER_KEY = 'e5gaw8eew1ocrf6r'
	PEER_ID  = Math.random().toString(36).substr(2, 5)

	console.log PEER_ID

	peer = new Peer PEER_ID, key: PEER_KEY

	$('#peer-id').text PEER_ID

	$('#connect').on 'click', ->
		conn = peer.connect $('#client').val()

		conn.on 'open', ->
			conn.send 'hi!'

		peer.on 'connection', (conn) ->
			conn.on 'data', (data) ->
			    console.log data
