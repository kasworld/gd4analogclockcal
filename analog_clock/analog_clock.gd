extends Node2D

var clock_R :float
var HourHand :Line2D
var HourHand2 :Line2D
var MinuteHand :Line2D
var SecondHand :Line2D
var tz_shift :float
var dial_nums :Array
var center_circle1 :Polygon2D
var center_circle2 :Polygon2D

# Called when the node enters the scene tree for the first time.
func init(center :Vector2 , r :float, tz_s :float) -> void:
	tz_shift = tz_s
	clock_R = r
	draw_dial(center, clock_R)
	draw_hand(center)
	center_circle1 = Global2d.new_circle_fill(center, clock_R/25, Global2d.colors.center_circle1)
	add_child(center_circle1)
	center_circle2 = Global2d.new_circle_fill(center, clock_R/30, Global2d.colors.center_circle2)
	add_child(center_circle2)

var gr_hand_hour_1 :Gradient
var gr_hand_hour_2 :Gradient
var gr_hand_minute :Gradient
var gr_hand_second :Gradient
func draw_hand(center :Vector2)->void:
	gr_hand_hour_1 = new_gradient(Global2d.colors.hour)
	gr_hand_hour_2 = new_gradient(Global2d.colors.hour2)
	gr_hand_minute = new_gradient(Global2d.colors.minute)
	gr_hand_second = new_gradient(Global2d.colors.second)
	HourHand = new_clock_hand(center, gr_hand_hour_1, 1.0/25, 0.7 )
	add_child(HourHand)
	HourHand2 = new_clock_hand(center, gr_hand_hour_2, 1.0/100, 0.65)
	add_child(HourHand2)
	MinuteHand = new_clock_hand(center, gr_hand_minute, 1.0/50, 0.9)
	add_child(MinuteHand)
	SecondHand = new_clock_hand(center, gr_hand_second, 1.0/100, 1.0)
	add_child(SecondHand)


var gr_360_1 :Gradient
var gr_360_2 :Gradient
var gr_90_1 :Gradient
var gr_90_2 :Gradient
var gr_30 :Gradient
var gr_6 :Gradient
var gr_1 :Gradient
func draw_dial(p :Vector2, r :float):
	var w = r/30
	gr_360_1 = new_gradient(Global2d.colors.dial_360_1)
	gr_360_2 = new_gradient(Global2d.colors.dial_360_2)
	gr_90_1 = new_gradient(Global2d.colors.dial_90_1)
	gr_90_2 = new_gradient(Global2d.colors.dial_90_2)
	gr_30 = new_gradient(Global2d.colors.dial_30)
	gr_6 = new_gradient(Global2d.colors.dial_6)
	gr_1 = new_gradient(Global2d.colors.dial_1)
	for i in range(0,360):
		var rad = deg2rad(i)
		if i == 0:
			add_child( new_clock_face( p, r, gr_360_1, rad, r/50, w*3, 0 ) )
			add_child( new_clock_face( p, r, gr_360_2, rad, r/200, w*3, 0 ) )
		elif i % 90 ==0:
			add_child( new_clock_face( p, r, gr_90_1, rad, r/100, w*3, 0 ) )
			add_child( new_clock_face( p, r, gr_90_2, rad, r/300, w*2, 0 ) )
		elif i % 30 == 0 :
			add_child( new_clock_face( p, r, gr_30, rad, r/150, w*3, 0 ) )
		elif i % 6 == 0 :
			add_child( new_clock_face( p, r, gr_6, rad, r/200, w*2, 0 ) )
		else :
			add_child( new_clock_face( p, r, gr_1, rad, r/400, w*1, 0 ) )

	for i in range(1,13):
		var n = hour_letter(p,r, i)
		dial_nums.append(n)
		add_child(n)

func update_color()->void:
	for n in dial_nums:
		Global2d.set_label_color(n,Global2d.colors.dial_num[0], Global2d.colors.dial_num[1] )
	gr_360_1.colors = Global2d.colors.dial_360_1
	gr_360_2.colors = Global2d.colors.dial_360_2
	gr_90_1.colors = Global2d.colors.dial_90_1
	gr_90_2.colors = Global2d.colors.dial_90_2
	gr_30.colors = Global2d.colors.dial_30
	gr_6.colors = Global2d.colors.dial_6
	gr_1.colors = Global2d.colors.dial_1
	gr_hand_hour_1.colors = Global2d.colors.hour
	gr_hand_hour_2.colors = Global2d.colors.hour2
	gr_hand_minute.colors = Global2d.colors.minute
	gr_hand_second.colors = Global2d.colors.second
	center_circle1.color = Global2d.colors.center_circle1
	center_circle2.color = Global2d.colors.center_circle2

func new_gradient(co_list :Array)->Gradient:
	var gr = Gradient.new()
	gr.colors = co_list
	return gr

func hour_letter(p :Vector2,r :float,  i :int)->Label:
	var lb = Label.new()
	lb.text = "%2d" % i
	lb.label_settings = Global2d.make_label_setting(clock_R/8, Global2d.colors.dial_num[0], Global2d.colors.dial_num[1])
	lb.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	lb.vertical_alignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER
	var rad = deg2rad( i*30.0 -90)
#	lb.rotation = rad + PI/2
	lb.position = Vector2( r*0.85 * cos(rad), r*0.85 * sin(rad) ) + p - Vector2(r*0.08,r*0.06)
	return lb

func new_clock_face(p :Vector2, r :float, gr :Gradient, rad :float, w :float, h :float, y :float) -> Line2D:
	var cr = Line2D.new()
	cr.gradient = gr
	cr.width = w
	cr.points = [Vector2(0,y-r), Vector2(0,y-r+h)]
	cr.rotation = rad
	cr.position = p
	cr.antialiased = true
	return cr

func new_clock_hand(p :Vector2, gr :Gradient, w :float, h: float) -> Line2D:
	var cr = Line2D.new()
	cr.gradient = gr
	cr.width = w*clock_R
	cr.points = [Vector2(0,-h*clock_R), Vector2(0,h*clock_R/8)]
	cr.begin_cap_mode = Line2D.LINE_CAP_ROUND
	cr.end_cap_mode = Line2D.LINE_CAP_ROUND
	cr.position = p
	cr.antialiased = true
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
