extends Node2D

func new_hour_clock_face(rad :float)->ColorRect:
	var w = 4
	var cr = ColorRect.new()
	cr.size = Vector2(w, 50)
	cr.position = Vector2(540-w/2, 0)
	cr.rotation = rad
	cr.pivot_offset = Vector2(w/2,540)
	return cr

func new_minute_clock_face(rad :float)->ColorRect:
	var w = 2
	var cr = ColorRect.new()
	cr.size = Vector2(w, 20)
	cr.position = Vector2(540-w/2, 0)
	cr.rotation = rad
	cr.pivot_offset = Vector2(w/2,540)
	return cr


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0,12):
		var cr = new_hour_clock_face(hour2degree(i))
		$Panel.add_child(cr)

	for i in range(0,60):
		var cr = new_minute_clock_face(minute2degree(i))
		$Panel.add_child(cr)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var timeNowDict = Time.get_datetime_dict_from_system()
	$Panel/SecondHand.rotation = second2degree(timeNowDict["second"])
	$Panel/MinuteHand.rotation = minute2degree(timeNowDict["minute"]) + second2degree(timeNowDict["second"]) / 60
	$Panel/HourHand.rotation = hour2degree(timeNowDict["hour"]) + minute2degree(timeNowDict["minute"]) /60

func second2degree(sec)->float:
	return 2.0*PI/60.0*sec

func minute2degree(min)->float:
	return 2.0*PI/60.0*min

func hour2degree(hour)->float:
	return 2.0*PI/12.0*hour
