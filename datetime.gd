extends Node

func now() -> String:
	# yyyy-MM-dd HH:mm:ss.SSS
	var current = Time.get_datetime_dict_from_system()
	var ms = int(Time.get_ticks_msec() % 1000)
	
	return "%04d-%02d-%02d %02d:%02d:%02d.%03d" % [
		current.year, current.month, current.day,
		current.hour, current.minute, current.second,
		ms
	]
