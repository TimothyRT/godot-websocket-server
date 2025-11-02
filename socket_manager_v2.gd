extends Node

const PORT := 9080
var ws_server := WebSocketMultiplayerPeer.new()
var connected_peers := []

var ip_address = IP.resolve_hostname(str(OS.get_environment("COMPUTERNAME")), IP.TYPE_IPV4)

var sensor_data = {
	"gyroscope": {
		"x": [],
		"y": [],
		"z": []
	},
	"accelerometer": {
		"x": [],
		"y": [],
		"z": []
	}
}

var plot = {
	"gyroscope": {
		"x": PlotItem,
		"y": PlotItem,
		"z": PlotItem
	},
	"accelerometer": {
		"x": PlotItem,
		"y": PlotItem,
		"z": PlotItem
	}
}


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
	
	setup_plot()
	
	
func setup_plot():
	plot["gyroscope"]["x"] = %GraphGyro.add_plot_item("Gyroscope", Color.RED)
	plot["gyroscope"]["y"] = %GraphGyro.add_plot_item("", Color.GREEN)
	plot["gyroscope"]["z"] = %GraphGyro.add_plot_item("", Color.BLUE)
	plot["accelerometer"]["x"] = %GraphAcc.add_plot_item("Accelerometer", Color.RED)
	plot["accelerometer"]["y"] = %GraphAcc.add_plot_item("", Color.GREEN)
	plot["accelerometer"]["z"] = %GraphAcc.add_plot_item("", Color.BLUE)


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
			
			var val_type: String
			var regex_type = RegEx.new()
			regex_type.compile("(Accelerometer)|(Gyroscope)")
			var match_type: RegExMatch = regex_type.search(msg)
			if match_type != null:
				val_type = match_type.get_string().to_lower()
				print("Type: " + val_type)
			else:
				print("Type: N/A")
			
			var regex_num = RegEx.new()
			regex_num.compile(":\\s(-?\\d+\\.\\d+)")
			var match_arr: Array[RegExMatch] = regex_num.search_all(msg)
			if len(match_arr) == 3:
				sensor_data[val_type]["x"].append(int(match_arr[0].get_string(1)))
				sensor_data[val_type]["y"].append(int(match_arr[1].get_string(1)))
				sensor_data[val_type]["z"].append(int(match_arr[2].get_string(1)))
				
			if len(sensor_data["gyroscope"]["x"]) > 100:
				sensor_data["gyroscope"]["x"] = sensor_data["gyroscope"]["x"].slice(1, 100)
				sensor_data["gyroscope"]["y"] = sensor_data["gyroscope"]["y"].slice(1, 100)
				sensor_data["gyroscope"]["z"] = sensor_data["gyroscope"]["z"].slice(1, 100)
				
			if len(sensor_data["accelerometer"]["x"]) > 100:
				sensor_data["accelerometer"]["x"] = sensor_data["accelerometer"]["x"].slice(1, 100)
				sensor_data["accelerometer"]["y"] = sensor_data["accelerometer"]["y"].slice(1, 100)
				sensor_data["accelerometer"]["z"] = sensor_data["accelerometer"]["z"].slice(1, 100)
			
			plot["gyroscope"]["x"].remove_all()
			plot["gyroscope"]["y"].remove_all()
			plot["gyroscope"]["z"].remove_all()
			for i in range(len(sensor_data["gyroscope"]["x"])):
				plot["gyroscope"]["x"].add_point(Vector2(i, sensor_data["gyroscope"]["x"][i]))
				plot["gyroscope"]["y"].add_point(Vector2(i, sensor_data["gyroscope"]["y"][i]))
				plot["gyroscope"]["z"].add_point(Vector2(i, sensor_data["gyroscope"]["z"][i]))
				
			plot["accelerometer"]["x"].remove_all()
			plot["accelerometer"]["y"].remove_all()
			plot["accelerometer"]["z"].remove_all()
			for i in range(len(sensor_data["accelerometer"]["x"])):
				plot["accelerometer"]["x"].add_point(Vector2(i, sensor_data["accelerometer"]["x"][i]))
				plot["accelerometer"]["y"].add_point(Vector2(i, sensor_data["accelerometer"]["y"][i]))
				plot["accelerometer"]["z"].add_point(Vector2(i, sensor_data["accelerometer"]["z"][i]))

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
