extends Node2D

#var vp_size :Vector2
var clock_R : float
var HourHand :Line2D
var HourHand2 :Line2D
var MinuteHand :Line2D
var SecondHand :Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var vp_size = get_viewport_rect().size
	clock_R = vp_size.y / 2

	add_child( Global.new_circle(clock_R, Color.DIM_GRAY, clock_R/200))
	add_child(Global.new_circle(clock_R-clock_R/20, Color.DIM_GRAY, clock_R/200))
	add_child(Global.new_circle(clock_R-clock_R/10, Color.DIM_GRAY, clock_R/200))

	draw_dial(0,0,clock_R)
	draw_dial(-clock_R/2, 0,clock_R/4)
	draw_dial( clock_R/2, 0,clock_R/4)


	HourHand = clock_hand(Global.HandDict.hour)
	add_child(HourHand)
	HourHand2 = clock_hand(Global.HandDict.hour2)
	add_child(HourHand2)
	MinuteHand = clock_hand(Global.HandDict.minute)
	add_child(MinuteHand)
	SecondHand = clock_hand(Global.HandDict.second)
	add_child(SecondHand)

	add_child(Global.new_circle_fill(clock_R/25, Color.GOLD))
	add_child(Global.new_circle_fill(clock_R/30, Color.DARK_GOLDENROD))

func draw_dial(x,y, r):
	for i in range(0,360):
		if i == 0:
			add_child( new_clock_face( Vector2(x,y), r, Color.WHITE, deg2rad(i), r/50, r/10, 0  ) )
			add_child( new_clock_face( Vector2(x,y), r, Color.RED, deg2rad(i), r/200, r/10, 0  ) )
		elif i % 90 ==0:
			add_child( new_clock_face( Vector2(x,y), r, Color.WHITE, deg2rad(i), r/100, r/10, 0  ) )
			add_child( new_clock_face( Vector2(x,y), r, Color.RED, deg2rad(i), r/300, r/20, r/20  ) )
		elif i % 30 == 0 :
			add_child( new_clock_face( Vector2(x,y), r, Color.WHITE, deg2rad(i), r/150, r/10, 0  ) )
		elif i % 6 == 0 :
			add_child( new_clock_face( Vector2(x,y), r, Color.WHITE, deg2rad(i), r/200, r/20, 0  ) )
		else :
			add_child( new_clock_face( Vector2(x,y), r, Color.WHITE, deg2rad(i), r/400, r/40, 0  ) )


func new_clock_face(p :Vector2,r, co :Color, rad :float, w , h, y ) -> Line2D:
	var cr = Line2D.new()
	cr.default_color = co
	cr.width = w
	cr.add_point(Vector2(0,y-r))
	cr.add_point(Vector2(0,y-r+h))
	cr.rotation = rad
	cr.position = p
	return cr

func clock_hand(dict :Dictionary) -> Line2D:
	var cr = Line2D.new()
	var pca : PackedColorArray = []
	pca.append(dict.color)
	pca.append(dict.color.darkened(0.5))
	var gr = Gradient.new()
	gr.colors = pca
	cr.gradient = gr
#	cr.default_color = dict.color
	cr.width = dict.width*clock_R
	cr.add_point(Vector2(0,-dict.height*clock_R))
	cr.add_point(Vector2(0,dict.height*clock_R/8))
	cr.begin_cap_mode = Line2D.LINE_CAP_ROUND
	cr.end_cap_mode = Line2D.LINE_CAP_ROUND
	return cr

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_clock()

func update_clock():
	var ms = Time.get_unix_time_from_system()
	ms = ms - int(ms)
	var timeNowDict = Time.get_datetime_dict_from_system()
	SecondHand.rotation = second2rad(timeNowDict["second"]) + ms2rad(ms)
	MinuteHand.rotation = minute2rad(timeNowDict["minute"]) + second2rad(timeNowDict["second"]) / 60
	HourHand.rotation = hour2rad(timeNowDict["hour"]) + minute2rad(timeNowDict["minute"]) /12
	HourHand2.rotation = HourHand.rotation

func deg2rad(deg :float) ->float :
	return deg * 2 * PI / 360

func ms2rad(ms) -> float:
	return 2.0*PI/60*ms

func second2rad(sec) -> float:
	return 2.0*PI/60.0*sec

func minute2rad(m) -> float:
	return 2.0*PI/60.0*m

func hour2rad(hour) -> float:
	return 2.0*PI/12.0*hour
