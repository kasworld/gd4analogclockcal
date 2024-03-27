extends Node2D

var info_text :InfoText

# Called when the node enters the scene tree for the first time.
func init(config :Dictionary, r :float, tz_s :float) -> void:
	$AnalogDialHour.init(r)
	var hands_param = {
		# from, to , width : ratio of clock_R
		hour1 = [0.5,0.8,0.03],
		hour2 = [0.55,0.75,0.01],
		minute = [0.6,0.9,0.02],
		second = [0.7,1.0,0.01],
	}
	$AnalogHands.init(r,tz_s, hands_param, false)

	var co = Global2d.colors.timelabel
	$LabelTime.position = Vector2(-r/3.0,-r*0.3)
	$LabelTime.label_settings = Global2d.make_label_setting(r/4, co)

	co = Global2d.colors.infolabel
	$LabelInfo.position = Vector2(-r/2.0,r*0.1)
	$LabelInfo.label_settings = Global2d.make_label_setting(r/8, co)

	info_text = InfoText.new()
	add_child(info_text)
	info_text.init_request(config.weather_url,config.dayinfo_url,config.todayinfo_url)
	info_text.text_updated.connect(_on_update_info_text)

	update_color()

func _on_update_info_text(t :String)->void:
	$LabelInfo.text = t

func update_req_url(cfg:Dictionary)->void:
	info_text.update_urls(cfg.weather_url,cfg.dayinfo_url,cfg.todayinfo_url)
	info_text.force_update()

func update_color()->void:
	$AnalogDialHour.update_color()
	$AnalogHands.update_color()
	$LabelTime.label_settings.font_color = Global2d.colors.timelabel
	$LabelInfo.label_settings.font_color = Global2d.colors.infolabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_clock()

var old_time_dict = {"second":0} # datetime dict
func update_clock():
	var time_now_dict = Time.get_datetime_dict_from_system()
	if old_time_dict["second"] != time_now_dict["second"]:
		old_time_dict = time_now_dict
		$LabelTime.text = "%02d:%02d:%02d" % [time_now_dict["hour"] , time_now_dict["minute"] ,time_now_dict["second"]  ]
