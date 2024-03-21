extends Node2D

var clock_R :float

var tz_shift :float
var dial_nums :Array
var center_circle1 :Polygon2D
var center_circle2 :Polygon2D

var info_text :InfoText

# Called when the node enters the scene tree for the first time.
func init(config :Dictionary, r :float, tz_s :float) -> void:
	tz_shift = tz_s
	clock_R = r
	draw_hand()
	center_circle1 = Global2d.new_circle_fill(Vector2(0,0), clock_R/25, Global2d.colors.center_circle1)
	add_child(center_circle1)
	center_circle2 = Global2d.new_circle_fill(Vector2(0,0), clock_R/30, Global2d.colors.center_circle2)
	add_child(center_circle2)

	$AnalogDial.init(r)

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

# dict to line2d
var hands_lines = {
	hour1 = null,
	hour2 = null,
	minute = null,
	second = null,
}
# dict to gradient
var hands_gradients = {
	hour1 = null,
	hour2 = null,
	minute = null,
	second = null,
}
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

func update_color()->void:
	$AnalogDial.update_color()
	for n in dial_nums:
		Global2d.set_label_color(n,Global2d.colors.dial_num[0], Global2d.colors.dial_num[1] )
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

func second2rad(sec :float) -> float:
	return 2.0*PI/60.0*sec

func minute2rad(m :float) -> float:
	return 2.0*PI/60.0*m

func hour2rad(hour :float) -> float:
	return 2.0*PI/12.0*hour
