extends Node


func now(for_filename: bool = false) -> String:
	# Returns the following if for_filename is false
	#   yyyy-MM-dd HH:mm:ss.SSS
	# Returns the following otherwise
	#   yyyy-MM-dd_HH-mm-ss-SSS
	
	var current = Time.get_datetime_dict_from_system()
	var ms = int(Time.get_ticks_msec() % 1000)
	
	var base_filename = "%04d-%02d-%02d %02d:%02d:%02d.%03d"
	if for_filename:
		base_filename = "%04d-%02d-%02d_%02d-%02d-%02d-%03d"
	
	return base_filename % [
		current.year, current.month, current.day,
		current.hour, current.minute, current.second,
		ms
	]
