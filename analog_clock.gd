extends Node2D

var clock_R :float
var HourHand :Line2D
var HourHand2 :Line2D
var MinuteHand :Line2D
var SecondHand :Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var vp_size = get_viewport_rect().size
	clock_R = vp_size.y / 2

	draw_dial(0,0,clock_R)
#	draw_dial(-clock_R/2, 0,clock_R/4)
#	draw_dial( clock_R/2, 0,clock_R/4)

	HourHand = clock_hand(Global.HandDict.hour)
	add_child(HourHand)
	HourHand2 = clock_hand(Global.HandDict.hour2)
	add_child(HourHand2)
	MinuteHand = clock_hand(Global.HandDict.minute)
	add_child(MinuteHand)
	SecondHand = clock_hand(Global.HandDict.second)
	add_child(SecondHand)

	add_child(Global.new_circle_fill(Vector2(0,0), clock_R/25, Color.GOLD))
	add_child(Global.new_circle_fill(Vector2(0,0), clock_R/30, Color.DARK_GOLDENROD))

func draw_dial(x :float,y :float, r :float):
#	add_child( Global.new_circle_fill(Vector2(x,y), r, Color.GRAY) )
#	add_child( Global.new_circle_fill(Vector2(x,y), r-r/20, Color.WEB_GRAY) )
#	add_child( Global.new_circle_fill(Vector2(x,y), r-r/10, Color.BLACK) )
	var center = Vector2(x,y)
	var w = r/30
#	add_child( Global.new_circle(center, r-w*0.5, Color.GRAY, w))
#	add_child(Global.new_circle(center, r-w*1.5, Color.WEB_GRAY, w))
#	add_child(Global.new_circle(center, r-w*2.5, Color.DIM_GRAY, w))
	add_child( Global.new_circle(center, r-w*0, Color.GRAY, w/15))
	add_child(Global.new_circle(center, r-w*1, Color.GRAY, w/15))
	add_child(Global.new_circle(center, r-w*2, Color.GRAY, w/15))
	add_child(Global.new_circle(center, r-w*3, Color.GRAY, w/15))
	for i in range(0,360):
		var rad = deg2rad(i)
		if i == 0:
			add_child( new_clock_face( center, r, Color.BLACK, Color.WHITE, rad, r/50, w*3, 0 ) )
			add_child( new_clock_face( center, r, Color.DARK_RED, Color.RED, rad, r/200, w*3, 0 ) )
		elif i % 90 ==0:
			add_child( new_clock_face( center, r, Color.BLACK, Color.WHITE, rad, r/100, w*3, 0 ) )
			add_child( new_clock_face( center, r, Color.DARK_RED, Color.RED, rad, r/300, w*2, 0 ) )
		elif i % 30 == 0 :
			add_child( new_clock_face( center, r, Color.BLACK, Color.WHITE, rad, r/150, w*3, 0 ) )
		elif i % 6 == 0 :
			add_child( new_clock_face( center, r, Color.BLACK, Color.WHITE, rad, r/200, w*2, 0 ) )
		else :
			add_child( new_clock_face( center, r, Color.BLACK, Color.WHITE, rad, r/400, w*1, 0 ) )


func new_clock_face(p :Vector2, r :float, co1 :Color, co2 :Color, rad :float, w :float, h :float, y :float) -> Line2D:
	var gr = Gradient.new()
	gr.colors = [co1, co2]
	var cr = Line2D.new()
#	cr.default_color = co
	cr.gradient = gr
	cr.width = w
	cr.points = [Vector2(0,y-r), Vector2(0,y-r+h)]
	cr.rotation = rad
	cr.position = p
	return cr

func clock_hand(dict :Dictionary) -> Line2D:
	var gr = Gradient.new()
	gr.colors = [dict.color, dict.color.darkened(0.5)]
	var cr = Line2D.new()
	cr.gradient = gr
	cr.width = dict.width*clock_R
	cr.points = [Vector2(0,-dict.height*clock_R), Vector2(0,dict.height*clock_R/8)]
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

func ms2rad(ms :float) -> float:
	return 2.0*PI/60*ms

func second2rad(sec :float) -> float:
	return 2.0*PI/60.0*sec

func minute2rad(m :float) -> float:
	return 2.0*PI/60.0*m

func hour2rad(hour :float) -> float:
	return 2.0*PI/12.0*hour
