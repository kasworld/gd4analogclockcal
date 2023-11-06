extends Node2D

var clock_R :float
var HourHand :Line2D
var HourHand2 :Line2D
var MinuteHand :Line2D
var SecondHand :Line2D
var tz_shift :float

# Called when the node enters the scene tree for the first time.
func init(center :Vector2 , r :float, tz_s :float) -> void:
	tz_shift = tz_s
	clock_R = r

	draw_dial(center, clock_R)
#	draw_dial(-clock_R/2, 0,clock_R/4)
#	draw_dial( clock_R/2, 0,clock_R/4)

	HourHand = clock_hand(center, Global.colors.hour, 1.0/25, 0.7 )
	add_child(HourHand)
	HourHand2 = clock_hand(center, Global.colors.hour2, 1.0/100, 0.65)
	add_child(HourHand2)
	MinuteHand = clock_hand(center, Global.colors.minute, 1.0/50, 0.9)
	add_child(MinuteHand)
	SecondHand = clock_hand(center, Global.colors.second, 1.0/100, 1.0)
	add_child(SecondHand)

	add_child(Global.new_circle_fill(center, clock_R/25, Global.colors.center_circle1))
	add_child(Global.new_circle_fill(center, clock_R/30, Global.colors.center_circle2))

func draw_dial(p :Vector2, r :float):
#	add_child( Global.new_circle_fill(p, r, Color.GRAY) )
#	add_child( Global.new_circle_fill(p, r-r/20, Color.WEB_GRAY) )
#	add_child( Global.new_circle_fill(p, r-r/10, Color.BLACK) )
	var w = r/30
#	add_child( Global.new_circle(p, r-w*0.5, Color.GRAY, w))
#	add_child(Global.new_circle(p, r-w*1.5, Color.WEB_GRAY, w))
#	add_child(Global.new_circle(p, r-w*2.5, Color.DIM_GRAY, w))
	add_child(Global.new_circle(p, r-w*0, Global.colors.outer_circle1, w/15))
	add_child(Global.new_circle(p, r-w*1, Global.colors.outer_circle2, w/15))
	add_child(Global.new_circle(p, r-w*2, Global.colors.outer_circle3, w/15))
	add_child(Global.new_circle(p, r-w*3, Global.colors.outer_circle4, w/15))
	for i in range(0,360):
		var rad = deg2rad(i)
		if i == 0:
			add_child( new_clock_face( p, r, Global.colors.dial_360_1, rad, r/50, w*3, 0 ) )
			add_child( new_clock_face( p, r, Global.colors.dial_360_2, rad, r/200, w*3, 0 ) )
		elif i % 90 ==0:
			add_child( new_clock_face( p, r, Global.colors.dial_90_1, rad, r/100, w*3, 0 ) )
			add_child( new_clock_face( p, r, Global.colors.dial_90_2, rad, r/300, w*2, 0 ) )
		elif i % 30 == 0 :
			add_child( new_clock_face( p, r, Global.colors.dial_30, rad, r/150, w*3, 0 ) )
		elif i % 6 == 0 :
			add_child( new_clock_face( p, r, Global.colors.dial_6, rad, r/200, w*2, 0 ) )
		else :
			add_child( new_clock_face( p, r, Global.colors.dial_1, rad, r/400, w*1, 0 ) )


func new_clock_face(p :Vector2, r :float, co_list :Array, rad :float, w :float, h :float, y :float) -> Line2D:
	var gr = Gradient.new()
	gr.colors = co_list
	var cr = Line2D.new()
	cr.gradient = gr
	cr.width = w
	cr.points = [Vector2(0,y-r), Vector2(0,y-r+h)]
	cr.rotation = rad
	cr.position = p
	return cr

func clock_hand(p :Vector2, co_list :Array, w :float, h: float) -> Line2D:
	var gr = Gradient.new()
	gr.colors = co_list
	var cr = Line2D.new()
	cr.gradient = gr
	cr.width = w*clock_R
	cr.points = [Vector2(0,-h*clock_R), Vector2(0,h*clock_R/8)]
	cr.begin_cap_mode = Line2D.LINE_CAP_ROUND
	cr.end_cap_mode = Line2D.LINE_CAP_ROUND
	cr.position = p
	return cr

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_clock()

func update_clock():
	var ms = Time.get_unix_time_from_system()
	var second = ms - int(ms/60)*60
	ms = ms / 60
	var minute = ms - int(ms/60)*60
	ms = ms / 60
	var hour = ms - int(ms/24)*24 + tz_shift
	SecondHand.rotation = second2rad(second)
	MinuteHand.rotation = minute2rad(minute)
	HourHand.rotation = hour2rad(hour)
	HourHand2.rotation = HourHand.rotation

func deg2rad(deg :float) ->float :
	return deg * 2 * PI / 360

func second2rad(sec :float) -> float:
	return 2.0*PI/60.0*sec

func minute2rad(m :float) -> float:
	return 2.0*PI/60.0*m

func hour2rad(hour :float) -> float:
	return 2.0*PI/12.0*hour
