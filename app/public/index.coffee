PEER_KEY = 'e5gaw8eew1ocrf6r'
PEER_ID  = Math.random().toString(36).substr(2, 5)

$peerIdHeader  = document.querySelector '.local-id'
$connectButton = document.querySelector 'button'
$clientInput   = document.querySelector 'input'
$output        = document.querySelector '.status'

peer = new Peer PEER_ID, key: PEER_KEY

$peerIdHeader.textContent = PEER_ID

log = (data, silent = false) ->
	console.log data
	$output.textContent = data unless silent

onConnectionOpened = (conn) -> ->
	log 'Connection open\n'
	conn.send 'hi!'

onConnectionData = (data) ->
	$output.value += "Connection received data: #{data}\n"

onPeerConnected = (conn) ->
	log 'Peer connected\n'
	conn.on 'data', onConnectionData

onConnectButtonClick = ->
	log 'Creating connection\n'
	conn = peer.connect $clientInput.value
	conn.on 'open', onConnectionOpened conn
	peer.on 'connection', onPeerConnected

$connectButton.addEventListener 'click', onConnectButtonClick
