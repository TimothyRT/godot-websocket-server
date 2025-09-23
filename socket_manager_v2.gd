extends Node

const PORT := 9080
var ws_server := WebSocketMultiplayerPeer.new()
var connected_peers := []

var ip_address = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")), IP.TYPE_IPV4)


func _ready():
	var err = ws_server.create_server(PORT)
	if err != OK:
		print("Failed to start WebSocket server: %s" % err)
		return
	
	# Hook into peer connect/disconnect
	ws_server.peer_connected.connect(_on_peer_connected)
	ws_server.peer_disconnected.connect(_on_peer_disconnected)

	print("WebSocket server listening on port %d" % PORT)
	print("Local IP address: ", ip_address)


func _process(_delta):
	ws_server.poll()
	
	if connected_peers.size() > 0:
		while ws_server.get_available_packet_count() > 0:
			var id = ws_server.get_packet_peer()
			var pkt = ws_server.get_packet()

			#if id == 1:
				#continue # skip server self

			var msg = pkt.get_string_from_utf8()
			print("< Got from %d: %s" % [id, msg])

			# broadcast to all other clients
			#for peer_id in connected_peers:
				#if peer_id != id and ws_server.is_peer_connected(peer_id):
					#ws_server.set_target_peer(peer_id)
					#ws_server.put_packet(msg.to_utf8_buffer())


func _on_peer_connected(id: int):
	print("Peer connected: ", id)
	connected_peers.append(id)


func _on_peer_disconnected(id: int):
	print("Peer disconnected: ", id)
	connected_peers.erase(id)
