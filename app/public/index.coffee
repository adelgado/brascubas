PEER_KEY = 'e5gaw8eew1ocrf6r'
LOCAL_ID  = Math.random().toString(36).substr(2, 5)

$labelLocalId   = document.querySelector '.local-id'
$buttonConnect  = document.querySelector '[data-action~="connect"]'
$inputPartnerId = document.querySelector 'input'
$labelOutput    = document.querySelector '.status'

peer = new Peer LOCAL_ID, key: PEER_KEY

$labelLocalId.textContent = LOCAL_ID

log = (data, silent = false) ->
	console.log data
	$labelOutput.textContent = data unless silent

onConnectionOpened = (conn) -> ->
	log 'Connection open\n'
	conn.send 'hi!'

onConnectionData = (data) ->
	$labelOutput.value += "Connection received data: #{data}\n"

onPeerConnected = (conn) ->
	log 'Peer connected\n'
	conn.on 'data', onConnectionData

onConnectButtonClick = ->
	log 'Creating connection\n'
	conn = peer.connect $inputPartnerId.value
	conn.on 'open', onConnectionOpened conn
	peer.on 'connection', onPeerConnected

$buttonConnect.addEventListener 'click', onConnectButtonClick
