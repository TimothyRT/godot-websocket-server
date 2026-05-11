extends Node

const PORT := 9080
var udp := PacketPeerUDP.new()

var client_ip := ""
var client_port := -1

var time_since_last_heartbeat := 0.0

func _ready() -> void:
	add_to_group("NetworkBridge")
	var err = udp.bind(PORT)
	if err != OK:
		print("[UDP] Failed to bind on port %d: %s" % [PORT, err])
		return
	print("[UDP] Listening on port %d" % PORT)
	print("[UDP] Local IP: ", IpAddress.ip)

func _process(_delta) -> void:
	while udp.get_available_packet_count() > 0:
		var packet = udp.get_packet()
		client_ip   = udp.get_packet_ip()
		client_port = udp.get_packet_port()
		var packet_type = packet[0]
		
		if packet_type == 1:
			_parse_binary_sensors(packet)
		else:
			var msg = packet.get_string_from_utf8()
			_parse_message(msg)

	if client_ip != "":
		time_since_last_heartbeat += _delta
		if time_since_last_heartbeat >= 1.0: 
			send_to_client("STATUS:ALIVE")
			time_since_last_heartbeat = 0.0

func _parse_binary_sensors(packet: PackedByteArray) -> void:
	if packet.size() < 27: 
		print("[UDP-ERROR] Received incomplete packet. Size: ", packet.size(), " bytes")
		return 
	#print("[UDP-RAW] ", packet.hex_encode())
	var sensor_sample = {
		"acc_x": packet.decode_float(2), "acc_y": packet.decode_float(6), "acc_z": packet.decode_float(10),
		"gyro_x": packet.decode_float(14), "gyro_y": packet.decode_float(18), "gyro_z": packet.decode_float(22),
		"gesture": packet[26] == 1
	}
	print("[UDP-SENSOR] Acc(%.2f, %.2f, %.2f) | Gyro(%.2f, %.2f, %.2f) | Gesture: %s" % [
		sensor_sample.acc_x, sensor_sample.acc_y, sensor_sample.acc_z,
		sensor_sample.gyro_x, sensor_sample.gyro_y, sensor_sample.gyro_z,
		str(sensor_sample.gesture)
	])
	SignalBus.client_sensor_retrieved.emit(sensor_sample)

func _parse_message(msg: String) -> void:
	if msg.begins_with("CMD:") or msg.begins_with("AXIS:") or msg.begins_with("BTN:"):
		_handle_command(msg)
		return

func _handle_command(msg: String) -> void:
	match msg:
		"CMD:PING":
			print("[UDP] Received PING from client — sending PONG")
			send_to_client("STATUS:PONG")
		_:
			print("[UDP] Unknown command: ", msg)

func send_to_client(msg: String) -> void:
	if client_ip == "" or client_port < 0:
		return
	udp.set_dest_address(client_ip, client_port)
	udp.put_packet(msg.to_utf8_buffer())

func stop_connection() -> void:
	print("[UDP] Shutting down")
	send_to_client("STATUS:DISCONNECTED")
	# Close socket
	udp.close()
	client_ip   = ""
	client_port = -1
