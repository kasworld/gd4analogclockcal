extends Node2D

var vp_rect :Rect2

var calendar_pos_list :Array
var timelabel_pos_list :Array
var analogclock_pos_list :Array
var infolabel_pos_list :Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_color_mode_by_time()

#	init_http()
	vp_rect = get_viewport_rect()

	bgimage = Image.create(vp_rect.size.x,vp_rect.size.y,true,Image.FORMAT_RGBA8)

	var calw = vp_rect.size.x-vp_rect.size.y
	if calw > vp_rect.size.x /2 :
		calw = vp_rect.size.y
	$Calendar.init( Rect2(-calw/2, -calw/2, calw, calw) )
	calendar_pos_list.append(Vector2(vp_rect.size.x-calw/2, vp_rect.size.y/2 ))
	calendar_pos_list.append(Vector2(calw/2, vp_rect.size.y/2 ))
	$Calendar.position = calendar_pos_list[0]

	var co :Color
	co = Global.colors.timelabel
	$TimeLabel.init(
		Rect2(-vp_rect.size.x/3/2, -vp_rect.size.y/4, vp_rect.size.x/3, vp_rect.size.y/6),
		co, Global.make_shadow_color(co))
	timelabel_pos_list.append(Vector2(vp_rect.size.y/2, vp_rect.size.y/2 ))
	timelabel_pos_list.append(Vector2(vp_rect.size.x - vp_rect.size.y/2, vp_rect.size.y/2 ))
	$TimeLabel.position = timelabel_pos_list[0]

	$AnalogClock.init( Vector2(0, 0), vp_rect.size.y/2 , 9.0 )
	analogclock_pos_list.append(Vector2(vp_rect.size.y/2, vp_rect.size.y/2 ))
	analogclock_pos_list.append(Vector2(vp_rect.size.x - vp_rect.size.y/2, vp_rect.size.y/2 ))
	$AnalogClock.position = analogclock_pos_list[0]

	co = Global.colors.infolabel
	$InfoLabel.init(
		Rect2(-vp_rect.size.x/3/2, vp_rect.size.y/20, vp_rect.size.x/3, vp_rect.size.y/2),
		co, Global.make_shadow_color(co) )
	infolabel_pos_list.append(Vector2(vp_rect.size.y/2, vp_rect.size.y/2 ))
	infolabel_pos_list.append(Vector2(vp_rect.size.x - vp_rect.size.y/2, vp_rect.size.y/2 ))
	$InfoLabel.position = timelabel_pos_list[0]

	co = Global.colors.paneloption
	var optrect = Rect2( vp_rect.size.x * 0.1 ,vp_rect.size.y * 0.3 , vp_rect.size.x * 0.8 , vp_rect.size.y * 0.4 )
	$PanelOption.init( optrect, co, Global.make_shadow_color(co))
	$PanelOption.config_changed.connect(config_changed)
	init_request_dict()

#	var msgrect = Rect2( vp_rect.size.x * 0.2 ,vp_rect.size.y * 0.4 , vp_rect.size.x * 0.6 , vp_rect.size.y * 0.2   )
#	$TimedMessage.init(msgrect, tr("gd4analogclockcal 2.1.0"))
#	$TimedMessage.show_message("Copyright 2023 SeukWon Kang (kasworld@gmail.com)")


func reset_pos()->void:
	$TimeLabel.position = timelabel_pos_list[0]
	$InfoLabel.position = timelabel_pos_list[0]
	$Calendar.position = calendar_pos_list[0]
	$AnalogClock.position = analogclock_pos_list[0]
	$AniMove.stop()

func animove_toggle()->void:
	$AniMove.toggle()
	if not $AniMove.enabled:
		reset_pos()

func animove_step():
	if not $AniMove.enabled:
		return
	var ms = $AniMove.get_ms()
	match $AniMove.state%2:
		0:
			$AniMove.move_by_ms($TimeLabel, timelabel_pos_list[0], timelabel_pos_list[1], ms)
			$AniMove.move_by_ms($InfoLabel, infolabel_pos_list[0], infolabel_pos_list[1], ms)
			$AniMove.move_by_ms($Calendar, calendar_pos_list[0], calendar_pos_list[1], ms)
			$AniMove.move_by_ms($AnalogClock, analogclock_pos_list[0], analogclock_pos_list[1], ms)
		1:
			$AniMove.move_by_ms($TimeLabel, timelabel_pos_list[1], timelabel_pos_list[0], ms)
			$AniMove.move_by_ms($InfoLabel, infolabel_pos_list[1], infolabel_pos_list[0], ms)
			$AniMove.move_by_ms($Calendar, calendar_pos_list[1], calendar_pos_list[0], ms)
			$AniMove.move_by_ms($AnalogClock, analogclock_pos_list[1], analogclock_pos_list[0], ms)
		_:
			print_debug("invalid state", $AniMove.state)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	animove_step()
	rot_by_accel()

var oldvt = Vector2(0,-100)
func rot_by_accel()->void:
	var vt = Input.get_accelerometer()
	if  vt != Vector3.ZERO :
		oldvt = (Vector2(vt.x,vt.y) + oldvt).normalized() *100
		var rad = oldvt.angle_to(Vector2(0,-1))
		rotate_all(rad)
	else :
		vt = Input.get_last_mouse_velocity()/100
		if vt == Vector2.ZERO :
			vt = Vector2(0,-5)
		oldvt = (Vector2(vt.x,vt.y) + oldvt).normalized() *100
		var rad = oldvt.angle_to(Vector2(0,-1))
		rotate_all(rad)

func rotate_all(rad :float):
	$AnalogClock.rotation = rad
	$TimeLabel.rotation = rad
	$InfoLabel.rotation = rad
	$Calendar.rotation = rad

# esc to exit
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		elif event.keycode == KEY_ENTER:
			_on_button_option_pressed()
		else:
			update_color(not Global.dark_mode)

	elif event is InputEventMouseButton and event.is_pressed():
		update_color(not Global.dark_mode)

func init_http():
	var ccr = ClockCalRouter.new()
	ccr.helloed.connect(helloed)
	var server = HttpServer.new()
	server.register_router("/", ccr)
	add_child(server)
	server.start()

func helloed():
	print_debug("helloed")

func config_changed():
	for k in request_dict:
		request_dict[k].url_to_get = $PanelOption.cfg.config[k]
		request_dict[k].force_update()

func _on_button_option_pressed() -> void:
	$PanelOption.visible = not $PanelOption.visible

func _on_auto_hide_option_panel_timeout() -> void:
	$PanelOption.hide()

var request_dict = {}
func init_request_dict()->void:
	request_dict["weather_url"] = MyHTTPRequest.new(
		$PanelOption.cfg.config["weather_url"],
		60,	$InfoLabel.weather_success, $InfoLabel.weather_fail,
	)
	request_dict["dayinfo_url"] = MyHTTPRequest.new(
		$PanelOption.cfg.config["dayinfo_url"],
		60, $InfoLabel.dayinfo_success, $InfoLabel.dayinfo_fail,
	)
	request_dict["todayinfo_url"] = MyHTTPRequest.new(
		$PanelOption.cfg.config["todayinfo_url"],
		60, $InfoLabel.todayinfo_success, $InfoLabel.todayinfo_fail,
	)
	request_dict["background_url"] = MyHTTPRequest.new(
		$PanelOption.cfg.config["background_url"],
		60, bgimage_success, bgimage_fail,
	)
	for k in request_dict:
		add_child(request_dict[k])

var bgimage :Image
func bgimage_success(body)->void:
	var image_error = bgimage.load_png_from_buffer(body)
	if image_error != OK:
		print("An error occurred while trying to display the image.")
	else:
		var bgTexture = ImageTexture.create_from_image(bgimage)
		bgTexture.set_size_override(get_viewport_rect().size)
		$BackgroundSprite.texture = bgTexture
func bgimage_fail()->void:
	$BackgroundSprite.texture = null

func set_color_mode_by_time()->void:
	var now = Time.get_datetime_dict_from_system()
	if now["hour"] < 6 or now["hour"] >= 18 :
		Global.set_dark_mode(true)
	else :
		Global.set_dark_mode(false)

func update_color(darkmode :bool)->void:
	Global.set_dark_mode(darkmode)
	$TimeLabel.update_color()
	$InfoLabel.update_color()
	$Calendar.update_color()

# change dark mode by time
var old_time_dict = Time.get_datetime_dict_from_system() # datetime dict
var old_minute_dict = Time.get_datetime_dict_from_system() # datetime dict
func _on_timer_day_night_timeout() -> void:
	var time_now_dict = Time.get_datetime_dict_from_system()

	if old_minute_dict["minute"] != time_now_dict["minute"]:
		$AniMove.start_with_step(1)
		old_minute_dict = time_now_dict

	if old_time_dict["hour"] != time_now_dict["hour"]:
		old_time_dict = time_now_dict
		match time_now_dict["hour"]:
			6:
				update_color(false)
			18:
				update_color(true)
			_:
#				update_color(not Global.dark_mode)
				pass


