extends Node2D

var clock_R :float

# dict to line2d
var hands_lines = {
	hour1 =null,
	hour2 =null,
	minute =null,
	second =null,
}
# dict to gradient
var hands_gradients = {
	hour1 =null,
	hour2 =null,
	minute =null,
	second =null,
}
var tz_shift :float
var dial_nums :Array
var center_circle1 :Polygon2D
var center_circle2 :Polygon2D

var info_text :InfoText

# Called when the node enters the scene tree for the first time.
func init(config :Dictionary, r :float, tz_s :float) -> void:
	tz_shift = tz_s
	clock_R = r
	draw_dial(clock_R)
	draw_hand()
	center_circle1 = Global2d.new_circle_fill(Vector2(0,0), clock_R/25, Global2d.colors.center_circle1)
	add_child(center_circle1)
	center_circle2 = Global2d.new_circle_fill(Vector2(0,0), clock_R/30, Global2d.colors.center_circle2)
	add_child(center_circle2)

	var co = Global2d.colors.timelabel
	$LabelTime.position = Vector2(-r/3.0,-r/2)
	$LabelTime.label_settings = Global2d.make_label_setting(r/4, co, co)

	co = Global2d.colors.infolabel
	$LabelInfo.position = Vector2(-r/2.0,r/4)
	$LabelInfo.label_settings = Global2d.make_label_setting(r/8, co, co)

	info_text = InfoText.new()
	add_child(info_text)
	info_text.init_request(config.weather_url,config.dayinfo_url,config.todayinfo_url)
	info_text.text_updated.connect(update_info_text)

	update_color()

func update_info_text(t :String)->void:
	$LabelInfo.text = t

func update_req_url(cfg:Dictionary)->void:
	info_text.update_urls(cfg.weather_url,cfg.dayinfo_url,cfg.todayinfo_url)
	info_text.force_update()

func draw_hand()->void:
	var hands_param = {
		hour1 =[1.0/25, 0.7],
		hour2 =[1.0/100, 0.65],
		minute =[1.0/50, 0.9],
		second =[1.0/100, 1.0],
	}
	for k in hands_gradients:
		hands_gradients[k] = new_gradient(Global2d.colors[k])
		hands_lines[k] = new_clock_hand(hands_gradients[k], hands_param[k][0],hands_param[k][1] )
		add_child(hands_lines[k])

var dial_gradient = {
	dial_360_1 = null,
	dial_360_2 = null,
	dial_90_1 = null,
	dial_90_2 = null,
	dial_30 = null,
	dial_6 = null,
	dial_1 = null,
}
var gr_360_1 :Gradient
var gr_360_2 :Gradient
var gr_90_1 :Gradient
var gr_90_2 :Gradient
var gr_30 :Gradient
var gr_6 :Gradient
var gr_1 :Gradient
func draw_dial(r :float):
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
			add_child( new_clock_face( r, gr_360_1, rad, r/50, w*3, 0 ) )
			add_child( new_clock_face( r, gr_360_2, rad, r/200, w*3, 0 ) )
		elif i % 90 ==0:
			add_child( new_clock_face( r, gr_90_1, rad, r/100, w*3, 0 ) )
			add_child( new_clock_face( r, gr_90_2, rad, r/300, w*2, 0 ) )
		elif i % 30 == 0 :
			add_child( new_clock_face( r, gr_30, rad, r/150, w*3, 0 ) )
		elif i % 6 == 0 :
			add_child( new_clock_face( r, gr_6, rad, r/200, w*2, 0 ) )
		else :
			add_child( new_clock_face( r, gr_1, rad, r/400, w*1, 0 ) )

	for i in range(1,13):
		var n = hour_letter(r, i)
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
	for k in hands_lines:
		hands_gradients[k].colors = Global2d.colors[k]
	center_circle1.color = Global2d.colors.center_circle1
	center_circle2.color = Global2d.colors.center_circle2

	var co = Global2d.colors.timelabel
	Global2d.set_label_color($LabelTime, co, Global2d.make_shadow_color(co))

	co = Global2d.colors.infolabel
	Global2d.set_label_color($LabelInfo, co, Global2d.make_shadow_color(co))

func new_gradient(co_list :Array)->Gradient:
	var gr = Gradient.new()
	gr.colors = co_list
	return gr

func hour_letter(r :float,  i :int)->Label:
	var lb = Label.new()
	lb.text = "%2d" % i
	lb.label_settings = Global2d.make_label_setting(clock_R/8, Global2d.colors.dial_num[0], Global2d.colors.dial_num[1])
	lb.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	lb.vertical_alignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER
	var rad = deg2rad( i*30.0 -90)
#	lb.rotation = rad + PI/2
	lb.position = Vector2( r*0.85 * cos(rad), r*0.85 * sin(rad) ) - Vector2(r*0.08,r*0.06)
	return lb

func new_clock_face(r :float, gr :Gradient, rad :float, w :float, h :float, y :float) -> Line2D:
	var cr = Line2D.new()
	cr.gradient = gr
	cr.width = w
	cr.points = [Vector2(0,y-r), Vector2(0,y-r+h)]
	cr.rotation = rad
	cr.antialiased = true
	return cr

func new_clock_hand(gr :Gradient, w :float, h: float) -> Line2D:
	var cr = Line2D.new()
	cr.gradient = gr
	cr.width = w*clock_R
	cr.points = [Vector2(0,-h*clock_R), Vector2(0,h*clock_R/8)]
	cr.begin_cap_mode = Line2D.LINE_CAP_ROUND
	cr.end_cap_mode = Line2D.LINE_CAP_ROUND
	cr.antialiased = true
	return cr

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_clock()

var old_time_dict = {"second":0} # datetime dict
func update_clock():
	var ms = Time.get_unix_time_from_system()
	var second = ms - int(ms/60)*60
	ms = ms / 60
	var minute = ms - int(ms/60)*60
	ms = ms / 60
	var hour = ms - int(ms/24)*24 + tz_shift
	hands_lines.second.rotation = second2rad(second)
	hands_lines.minute.rotation = minute2rad(minute)
	hands_lines.hour1.rotation = hour2rad(hour)
	hands_lines.hour2.rotation = hour2rad(hour)

	var time_now_dict = Time.get_datetime_dict_from_system()
	if old_time_dict["second"] != time_now_dict["second"]:
		old_time_dict = time_now_dict
		$LabelTime.text = "%02d:%02d:%02d" % [time_now_dict["hour"] , time_now_dict["minute"] ,time_now_dict["second"]  ]


func deg2rad(deg :float) ->float :
	return deg * 2 * PI / 360

func second2rad(sec :float) -> float:
	return 2.0*PI/60.0*sec

func minute2rad(m :float) -> float:
	return 2.0*PI/60.0*m

func hour2rad(hour :float) -> float:
	return 2.0*PI/12.0*hour
