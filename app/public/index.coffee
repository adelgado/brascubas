PEER_KEY = 'e5gaw8eew1ocrf6r'
PEER_ID  = Math.random().toString(36).substr(2, 5)

$peerIdHeader  = document.querySelector 'h1'
$connectButton = document.querySelector 'button'
$clientInput   = document.querySelector 'input'
$output        = document.querySelector 'textarea'

peer = new Peer PEER_ID, key: PEER_KEY

$peerIdHeader.textContent = "Peer ID: #{PEER_ID}"

$connectButton.addEventListener 'click', ->
	conn = peer.connect $clientInput.value

	$output.value += 'Creating connection\n'

	conn.on 'open', ->
		$output.value += 'Connection open\n'

		conn.send 'hi!'

	peer.on 'connection', (conn) ->
		$output.value += 'Connection connected\n'

		conn.on 'data', (data) ->
			$output.value += "Connection received data: #{data}\n"
