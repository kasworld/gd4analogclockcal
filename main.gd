extends Node2D

var vp_size :Vector2
var calendar_pos_list :Array
var analogclock_pos_list :Array

var file_name = "gd4analogclockcal_config.json"
var editable_keys = [
	"weather_url",
	"dayinfo_url",
	"todayinfo_url",
	"background_url",
	]
var config = {
	"version" : "gd4analogclockcal 13.1.0",
	"weather_url" : "http://192.168.0.10/weather.txt",
	"dayinfo_url" : "http://192.168.0.10/dayinfo.txt",
	"todayinfo_url" : "http://192.168.0.10/todayinfo.txt",
	"background_url" : "http://192.168.0.10/background.png",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	config = Config.load_or_save(file_name,config,"version" )
	set_color_mode_by_time()
	vp_size = get_viewport_rect().size

	bgimage = Image.create(vp_size.x,vp_size.y,true,Image.FORMAT_RGBA8)

	var sect_width = min(vp_size.x/2,vp_size.y)
	calendar_pos_list = [Vector2(sect_width/2,vp_size.y/2),Vector2(vp_size.x - sect_width/2,vp_size.y/2)]
	analogclock_pos_list = calendar_pos_list.duplicate()
	analogclock_pos_list.reverse()

	$Calendar2.init( Vector2( sect_width, sect_width) )
	$Calendar2.position = calendar_pos_list[0]

	$AnalogClock.init(config, sect_width/2, 9 )
	$AnalogClock.position = analogclock_pos_list[0]

	var optrect = Rect2( vp_size.x * 0.1 ,vp_size.y * 0.3 , vp_size.x * 0.8 , vp_size.y * 0.4 )
	$PanelOption.init(file_name,config,editable_keys, optrect)
	$PanelOption.config_changed.connect(config_changed)
	$PanelOption.config_reset_req.connect(panel_config_reset_req)
	init_request_bg()

func reset_pos()->void:
	$Calendar2.position = calendar_pos_list[0]
	$AnalogClock.position = analogclock_pos_list[0]
	$AniMove2D.stop()

func animove_toggle()->void:
	$AniMove2D.toggle()
	if not $AniMove2D.enabled:
		reset_pos()

func animove_step():
	if not $AniMove2D.enabled:
		return
	var ms = $AniMove2D.get_ms()
	$AniMove2D.move_node2d($Calendar2, calendar_pos_list, ms)
	$AniMove2D.move_node2d($AnalogClock, analogclock_pos_list, ms)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	animove_step()
	rot_by_accel()

func _notification(what: int) -> void:
	# app resume on android
	if what == NOTIFICATION_APPLICATION_RESUMED :
		set_color_mode_by_time()
		update_color()

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
	$Calendar2.rotation = rad

# esc to exit
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		elif event.keycode == KEY_ENTER:
			_on_button_option_pressed()
		else:
			update_color_with_mode(not Global2d.dark_mode)

	elif event is InputEventMouseButton and event.is_pressed():
		update_color_with_mode(not Global2d.dark_mode)

func _on_button_option_pressed() -> void:
	$PanelOption.visible = not $PanelOption.visible

func _on_auto_hide_option_panel_timeout() -> void:
	$PanelOption.hide()

func panel_config_reset_req()->void:
	$PanelOption.config_to_control(file_name,config,editable_keys)

func config_changed(cfg :Dictionary):
	#update config
	for k in cfg:
		config[k]=cfg[k]
	bg_request.url_to_get = config["background_url"]
	bg_request.force_update()

var bg_request :MyHTTPRequest
func init_request_bg()->void:
	bg_request = MyHTTPRequest.new(
		config["background_url"],
		60, bgimage_success, bgimage_fail,
	)
	add_child(bg_request)

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
		Global2d.set_dark_mode(true)
	else :
		Global2d.set_dark_mode(false)

func update_color()->void:
	$Calendar2.update_color()
	$AnalogClock.update_color()

func update_color_with_mode(darkmode :bool)->void:
	Global2d.set_dark_mode(darkmode)
	$Calendar2.update_color()
	$AnalogClock.update_color()

# change dark mode by time
var old_time_dict = Time.get_datetime_dict_from_system() # datetime dict
var old_minute_dict = Time.get_datetime_dict_from_system() # datetime dict
func _on_timer_day_night_timeout() -> void:
	var time_now_dict = Time.get_datetime_dict_from_system()
	if old_minute_dict["minute"] != time_now_dict["minute"]:
		$AniMove2D.start_with_step(1)
		old_minute_dict = time_now_dict

	if old_time_dict["hour"] != time_now_dict["hour"]:
		old_time_dict = time_now_dict
		match time_now_dict["hour"]:
			6:
				update_color_with_mode(false)
			18:
				update_color_with_mode(true)
			_:
#				update_color(not Global2d.dark_mode)
				pass
