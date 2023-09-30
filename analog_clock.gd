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

func setfontshadow(o, fontcolor,offset):
	o.add_theme_color_override("font_color", fontcolor )
	o.add_theme_color_override("font_shadow_color", fontcolor.lightened(0.5) )
	o.add_theme_constant_override("shadow_offset_x",offset)
	o.add_theme_constant_override("shadow_offset_y",offset)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setfontshadow($LabelTime, Color.BLACK, 4)

	for i in range(0,12):
		var cr = new_hour_clock_face(hour2rad(i))
		$Panel.add_child(cr)

	for i in range(0,60):
		var cr = new_minute_clock_face(minute2rad(i))
		$Panel.add_child(cr)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_clock()

func update_clock():
	var ms = Time.get_unix_time_from_system()
	ms = ms - int(ms)
	var timeNowDict = Time.get_datetime_dict_from_system()
	$LabelTime.text = "%02d:%02d:%02d" % [timeNowDict["hour"] , timeNowDict["minute"] ,timeNowDict["second"]  ]
	$Panel/SecondHand.rotation = second2rad(timeNowDict["second"]) + ms2rad(ms)
	$Panel/MinuteHand.rotation = minute2rad(timeNowDict["minute"]) + second2rad(timeNowDict["second"]) / 60
	$Panel/HourHand.rotation = hour2rad(timeNowDict["hour"]) + minute2rad(timeNowDict["minute"]) /12

func ms2rad(ms)->float:
	return 2.0*PI/60*ms

func second2rad(sec)->float:
	return 2.0*PI/60.0*sec

func minute2rad(min)->float:
	return 2.0*PI/60.0*min

func hour2rad(hour)->float:
	return 2.0*PI/12.0*hour
