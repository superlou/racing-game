class_name Humanize

static func elapsed_time_hh_ss(time:float) -> String:
	var minutes := int(time / 60)
	var seconds := time - 60 * minutes
	return "%02d:%05.2f" % [minutes, seconds]