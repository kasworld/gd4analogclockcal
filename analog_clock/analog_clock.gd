extends Node2D

var info_text :InfoText
var clock_radius :float
var tz_shift :float

# use for calc hand angle
enum HandType {Hour, Minute, Second}

# default
var hands_param := [
	# hands type, color key,outline w :0 fill,  from, to , width : ratio of clock_radius
	[HandType.Hour, "hour1",8, 0.04,0.7, 0.04],
	[HandType.Hour, "hour2",0, 0.04,0.68, 0.01],
	[HandType.Minute, "minute",8, 0.04,0.9, 0.02],
	[HandType.Second, "second",0, 0.04,1.0, 0.01],
]
func draw_hands(time_sec :float) -> void:
	var hands_rad := calc_rad_for_hand(time_sec)
	for v in hands_param:
		var rad := hands_rad[v[0]] +PI
		var co :Color = Global2d.colors[v[1]]
		var outline :float = v[2]
		var p1 := Vector2(0, v[3]*clock_radius)
		var p2 := Vector2(0, v[4]*clock_radius)
		var w :float = v[5]*clock_radius
		draw_set_transform(Vector2(0,0), rad)
		var rt := Rect2(p1-Vector2(w/2,0), p2-p1 + Vector2(w,0))
		if outline == 0:
			draw_rect(rt,co,true)
		else:
			draw_rect(rt,co,false,outline)
	draw_set_transform(Vector2(0,0), 0)

func calc_rad_for_hand(ms :float) -> Array[float]:
	var second := ms - int(ms/60)*60
	ms = ms / 60
	var minute := ms - int(ms/60)*60
	ms = ms / 60
	var hour := ms - int(ms/24)*24 + tz_shift
	return [PI/6.0*hour, PI/30.0*minute, PI/30.0*second]


var center_param := [
	# color key, radius , ourline w:0 fill
	["center_circle1", 0.04, 4],
	["center_circle2", 0.025, 4],
]
func draw_center() -> void:
	for v in center_param:
		var co :Color = Global2d.colors[v[0]]
		var r :float = clock_radius * v[1]
		var outline :float = v[2]
		if outline == 0:
			draw_circle(Vector2(0,0), r, co)
		else:
			draw_arc(Vector2(0,0), r, 0, 2*PI, r as int, co, outline)


enum BarAlign {In,Mid,Out}
## offset_setting : [ [ modint, r rate ]... ]
const offset_setting := [
		[30, 0.08],
		[5,  0.04],
		[1,  0.02],
	]
func make_dial_lines(r :float) -> void:
	for i in range(0,360):
		var rad := deg_to_rad(i) -PI/2
		var offset :float = 0
		for os in offset_setting:
			if i % os[0] == 0:
				offset = r * os[1]
				break
		match dial_line_align:
			BarAlign.In :
				dial_lines.append_array([ make_pos_by_rad_r(rad,r-offset), make_pos_by_rad_r(rad,r) ])
			BarAlign.Mid :
				dial_lines.append_array([ make_pos_by_rad_r(rad,r-offset/2), make_pos_by_rad_r(rad,r+offset/2) ])
			BarAlign.Out :
				dial_lines.append_array([ make_pos_by_rad_r(rad,r), make_pos_by_rad_r(rad,r+offset) ])

func make_pos_by_rad_r(rad:float, r :float) -> Vector2:
	return Vector2(cos(rad)*r, sin(rad)*r)

var dial_line_radius :float
var dial_line_thick :float
var dial_line_align :BarAlign
var dial_line_colorkey :String
var dial_lines :PackedVector2Array =[]

var dial_text_radius :float
var dial_text_font_size :float
var dial_text_outline_w :int
var dial_text_colorkey :String

## true show num
var show_num_or_bar :bool

func update_color() -> void:
	queue_redraw()
	$LabelTime.label_settings.font_color = Global2d.colors.timelabel
	$LabelInfo.label_settings.font_color = Global2d.colors.infolabel

func init(config :Dictionary, r :float, tz_s :float) -> void:
	dial_line_radius = r
	dial_line_thick = r*0.006
	if dial_line_thick < 1:
		dial_line_thick = -1
	dial_line_align = BarAlign.In
	dial_line_colorkey = "dial_line"
	make_dial_lines(dial_line_radius)

	dial_text_radius = r *0.95
	dial_text_font_size = r*0.15
	dial_text_outline_w = 0
	dial_text_colorkey = "dial_num"

	clock_radius = r
	tz_shift = tz_s

	var co :Color = Global2d.colors.timelabel
	$LabelTime.position = Vector2(-r,-r)
	$LabelTime.size = Vector2(r*2,r*1.0)
	$LabelTime.label_settings = Global2d.make_label_setting(r*0.45 as int, co)

	co = Global2d.colors.infolabel
	$LabelInfo.position = Vector2(-r,0)
	$LabelInfo.size = Vector2(r*2,r*1.0)
	$LabelInfo.label_settings = Global2d.make_label_setting(r*0.2 as int, co)

	info_text = InfoText.new()
	add_child(info_text)
	info_text.init_request(
		config.base_url + config.weather_file,
		config.base_url + config.dayinfo_file,
		config.base_url + config.todayinfo_file)
	info_text.text_updated.connect(_on_update_info_text)

	update_color()

func _on_update_info_text(t :String) -> void:
	$LabelInfo.text = t

func update_req_url(cfg:Dictionary) -> void:
	info_text.update_urls(cfg.weather_url,cfg.dayinfo_url,cfg.todayinfo_url)
	info_text.force_update()

func update_label_time(time_now_dict :Dictionary) -> void:
	$LabelTime.text = "%02d:%02d:%02d" % [time_now_dict["hour"] , time_now_dict["minute"] ,time_now_dict["second"]  ]

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var ms := Time.get_unix_time_from_system()
	draw_hands(ms)
	draw_center()
	if show_num_or_bar:
		draw_dial_text(hour_list)
	else:
		draw_multiline(dial_lines, Global2d.colors[dial_line_colorkey], dial_line_thick)

const hour_list := [12,1,2,3,4,5,6,7,8,9,10,11]
#  ["열둘", "하나", "둘" , "셋", "넷", "다섯", "여섯", "일곱", "여덟", "아홉", "열", "열하나"]
const minute_list := [0,5,10,15,20,25,30,35,40,45,50,55]
func draw_dial_text(dial_text_list :Array) -> void:
	var co :Color = Global2d.colors[dial_text_colorkey]
	var unit_rad := 2*PI/dial_text_list.size()
	for i in dial_text_list.size():
		var rad := i*unit_rad -PI/2
		var pos := make_pos_by_rad_r(rad, dial_text_radius)
		draw_letter(pos, dial_text_font_size, "%s" % dial_text_list[i], co)

func draw_letter(pos :Vector2, fsize :float, txt :String, co :Color) -> void:
	pos += Vector2(-fsize/3.5 * txt.length(), fsize/3)
	if dial_text_outline_w == 0:
		draw_string(Global2d.font, pos, txt, HORIZONTAL_ALIGNMENT_CENTER, -1, fsize as int, co )
	else:
		draw_string_outline(Global2d.font, pos, txt, HORIZONTAL_ALIGNMENT_CENTER, -1, fsize as int, dial_text_outline_w, co )
