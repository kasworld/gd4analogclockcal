extends Node2D

#var vp_size :Vector2
var clock_R : float
var HourHand :ColorRect
var HourHand2 :ColorRect
var MinuteHand :ColorRect
var SecondHand :ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var vp_size = get_viewport_rect().size
	clock_R = vp_size.y / 2

	add_child(new_circle(clock_R, Color.DIM_GRAY))
	add_child(new_circle(clock_R-2, Color.BLACK))

	for i in range(0,60):
		if i == 0:
			add_child( new_clock_face( Color.WHITE, minute2rad(i), clock_R/40, clock_R/10 ) )
			add_child( new_clock_face( Color.RED, minute2rad(i), clock_R/100, clock_R/10 ) )
		elif i % 15 ==0:
			add_child( new_clock_face( Color.WHITE, minute2rad(i), clock_R/50, clock_R/10 ) )
			add_child( new_clock_face( Color.MAGENTA, minute2rad(i), clock_R/200, clock_R/10 ) )
		elif i % 5 == 0 :
			add_child( new_clock_face( Color.WHITE, minute2rad(i), clock_R/150, clock_R/10 ) )
		else :
			add_child( new_clock_face( Color.WHITE, minute2rad(i), clock_R/200, clock_R/20 ) )

	HourHand = clock_hand(Global.HandDict.hour)
	add_child(HourHand)
	HourHand2 = clock_hand(Global.HandDict.hour2)
	add_child(HourHand2)
	MinuteHand = clock_hand(Global.HandDict.minute)
	add_child(MinuteHand)
	SecondHand = clock_hand(Global.HandDict.second)
	add_child(SecondHand)

	add_child(new_circle(clock_R/25, Color.DIM_GRAY))
	add_child(new_circle(clock_R/27, Color.BLACK))

func new_circle(r,co)->Polygon2D :
	var rtn = Polygon2D.new()
	var pv2a : PackedVector2Array = []
	for i in 360 :
		var v2 = Vector2(sin(i*2*PI/360)*r, cos(i*2*PI/360)*r)
		pv2a.append(v2)
	rtn.polygon = pv2a
	rtn.color = co
	return rtn

func new_clock_face2(co :Color, rad :float, w , h, y )->ColorRect:
	var cr = ColorRect.new()
	cr.color = co
	cr.size = Vector2(w, h)
	cr.position = Vector2(clock_R-w/2, y) - Vector2(clock_R,clock_R)
	cr.rotation = rad
	cr.pivot_offset = Vector2(w/2,clock_R-y)
	return cr

func new_clock_face(co :Color, rad :float, w , h )->ColorRect:
	var cr = ColorRect.new()
	cr.color = co
	cr.size = Vector2(w, h)
	cr.position = Vector2(clock_R-w/2, 0) - Vector2(clock_R,clock_R)
	cr.rotation = rad
	cr.pivot_offset = Vector2(w/2,clock_R)
	return cr

func clock_hand(dict :Dictionary)->ColorRect:
	var cr = ColorRect.new()
	cr.color = dict.color
	cr.anchors_preset = Control.PRESET_CENTER_BOTTOM
	cr.size = Vector2(dict.width*clock_R, dict.height*clock_R)
	cr.position = Vector2(-dict.width*clock_R/2, -dict.height*clock_R/8)
	cr.rotation = 0
	cr.pivot_offset = Vector2(dict.width*clock_R/2,dict.height*clock_R/8)
	return cr

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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

func minute2rad(m)->float:
	return 2.0*PI/60.0*m

func hour2rad(hour)->float:
	return 2.0*PI/12.0*hour
