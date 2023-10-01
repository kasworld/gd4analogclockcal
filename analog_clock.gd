extends Node2D

func new_clock_face(rad :float, w , l )->ColorRect:
	var cr = ColorRect.new()
	cr.size = Vector2(w, l)
	cr.position = Vector2(540-w/2, 0)
	cr.rotation = rad
	cr.pivot_offset = Vector2(w/2,540)
	return cr

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	for i in range(0,60):
		if i == 0:
			var cr = new_clock_face(minute2rad(i), 10, 50)
			add_child(cr)
		elif i % 15 ==0:
			var cr = new_clock_face(minute2rad(i), 6, 50)
			add_child(cr)
		elif i % 5 == 0 :
			var cr = new_clock_face(minute2rad(i), 4, 50)
			add_child(cr)
		else :
			var cr = new_clock_face(minute2rad(i), 2, 20)
			add_child(cr)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_clock()

func update_clock():
	var ms = Time.get_unix_time_from_system()
	ms = ms - int(ms)
	var timeNowDict = Time.get_datetime_dict_from_system()
	$SecondHand.rotation = second2rad(timeNowDict["second"]) + ms2rad(ms)
	$MinuteHand.rotation = minute2rad(timeNowDict["minute"]) + second2rad(timeNowDict["second"]) / 60
	$HourHand.rotation = hour2rad(timeNowDict["hour"]) + minute2rad(timeNowDict["minute"]) /12

func ms2rad(ms)->float:
	return 2.0*PI/60*ms

func second2rad(sec)->float:
	return 2.0*PI/60.0*sec

func minute2rad(min)->float:
	return 2.0*PI/60.0*min

func hour2rad(hour)->float:
	return 2.0*PI/12.0*hour
