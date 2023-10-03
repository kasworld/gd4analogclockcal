extends Node2D

func new_clock_face(co :Color, rad :float, w , l )->ColorRect:
	var cr = ColorRect.new()
	cr.color = co
	cr.size = Vector2(w, l)
	cr.position = Vector2(540-w/2, 0) - Vector2(540,540)
	cr.rotation = rad
	cr.pivot_offset = Vector2(w/2,540)
	return cr

func clock_hand(dict :Dictionary)->ColorRect:
	var cr = ColorRect.new()
	cr.color = dict.color
	cr.anchors_preset = Control.PRESET_CENTER_BOTTOM
	cr.size = Vector2(dict.width, dict.height)
	cr.position = Vector2(-dict.width/2, -dict.height/10)
	cr.rotation = 0
	cr.pivot_offset = Vector2(dict.width/2,dict.height/10)
	return cr

func new_clock_center(co :Color, rad :float, r )->ColorRect:
	var cr = ColorRect.new()
	cr.color = co
	cr.size = Vector2(r, r)
	cr.position = Vector2(0, 0) - Vector2(r/2,r/2)
	cr.rotation = rad
	cr.pivot_offset = Vector2(r/2,r/2) #- Vector2(540,540)
	return cr


var HourHand :ColorRect
var HourHand2 :ColorRect
var MinuteHand :ColorRect
var SecondHand :ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	for i in range(0,60):
		if i == 0:
			add_child(new_clock_face(Color.WHITE, minute2rad(i), 10, 50))
			add_child(new_clock_face(Color.RED, minute2rad(i), 4, 48))
		elif i % 15 ==0:
			add_child(new_clock_face(Color.WHITE, minute2rad(i), 6, 50))
			add_child(new_clock_face(Color.MAGENTA, minute2rad(i), 2, 48))
		elif i % 5 == 0 :
			add_child(new_clock_face(Color.WHITE, minute2rad(i), 4, 50))
		else :
			add_child(new_clock_face(Color.WHITE, minute2rad(i), 2, 20))

	HourHand = clock_hand(Global.HandDict.hour)
	add_child(HourHand)
	HourHand2 = clock_hand(Global.HandDict.hour2)
	add_child(HourHand2)
	MinuteHand = clock_hand(Global.HandDict.minute)
	add_child(MinuteHand)
	SecondHand = clock_hand(Global.HandDict.second)
	add_child(SecondHand)

	add_child(new_clock_center(Color.GRAY, PI/4, 30))
	add_child(new_clock_center(Color.DIM_GRAY, PI/4, 20))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_clock()

func update_clock():
	var ms = Time.get_unix_time_from_system()
	ms = ms - int(ms)
	var timeNowDict = Time.get_datetime_dict_from_system()
	SecondHand.rotation = PI + second2rad(timeNowDict["second"]) + ms2rad(ms)
	MinuteHand.rotation = PI + minute2rad(timeNowDict["minute"]) + second2rad(timeNowDict["second"]) / 60
	HourHand.rotation = PI + hour2rad(timeNowDict["hour"]) + minute2rad(timeNowDict["minute"]) /12
	HourHand2.rotation = HourHand.rotation

func ms2rad(ms)->float:
	return 2.0*PI/60*ms

func second2rad(sec)->float:
	return 2.0*PI/60.0*sec

func minute2rad(min)->float:
	return 2.0*PI/60.0*min

func hour2rad(hour)->float:
	return 2.0*PI/12.0*hour
