class_name Humanize

static func elapsed_time_hh_ss(time:float) -> String:
	var minutes := int(time / 60)
	var seconds := time - 60 * minutes
	return "%02d:%05.2f" % [minutes, seconds]


static func place(order:int) -> String:
	if order >= 4 and order <= 20:
		return "%dth" % order
	
	match order % 10:
		1:
			return "%dst" % order
		2:
			return "%dnd" % order
		3:
			return "%drd" % order
		_:
			return "%dth" % order
