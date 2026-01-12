extends Node2D

var config = {
	"base_url" : "http://192.168.0.10/",
	"weather_file" : "weather.txt",
	"dayinfo_file" : "dayinfo.txt",
	"todayinfo_file" : "todayinfo.txt",
	"background_file" : "background.png",
}

var main_animation := SimpleAnimation.new()
var anipos_list := []
func reset_pos()->void:
	$AnalogClock.position = anipos_list[0]
	$Calendar.position = anipos_list[1]
func start_move_animation():
	main_animation.start_move("clock",$AnalogClock, anipos_list[0], anipos_list[1], 1)
	main_animation.start_move("clock",$Calendar, anipos_list[1], anipos_list[0], 1)
	anipos_list = [anipos_list[1], anipos_list[0]]

func on_viewport_size_changed() -> void:
	var vp_size := get_viewport().get_visible_rect().size
	var 짧은길이 :float = min(vp_size.x, vp_size.y)
	var panel_size := Vector2(vp_size.x/2 - 짧은길이/2, vp_size.y)
	$"왼쪽패널".size = panel_size
	$"왼쪽패널".custom_minimum_size = panel_size
	$오른쪽패널.size = panel_size
	$"오른쪽패널".custom_minimum_size = panel_size
	$오른쪽패널.position = Vector2(vp_size.x/2 + 짧은길이/2, 0)

	$"왼쪽패널/LabelVersion".text = "%s %s" % [
			ProjectSettings.get_setting("application/config/name"),
			ProjectSettings.get_setting("application/config/version"),
			]
	var msg := ""
	for k in config:
		msg += "%s : %s\n" % [k, config[k] ]
	$"왼쪽패널/LabelConfig".text = msg

func label_demo() -> void:
	if $"오른쪽패널/LabelPerformance".visible:
		$"오른쪽패널/LabelPerformance".text = """%d FPS (%.2f mspf)""" % [
		Engine.get_frames_per_second(),1000.0 / Engine.get_frames_per_second(),
		]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_viewport_size_changed()
	get_viewport().size_changed.connect(on_viewport_size_changed)
	_on_button_패널보이기_pressed()

	#SunRiseSet.test()
	set_color_mode_by_time()
	var vp_size = get_viewport_rect().size

	bgimage = Image.create(vp_size.x,vp_size.y,true,Image.FORMAT_RGBA8)

	var sect_width = min(vp_size.x/2,vp_size.y)
	anipos_list = [Vector2(sect_width/2,vp_size.y/2), Vector2(vp_size.x - sect_width/2,vp_size.y/2)]
	$Calendar.init( Vector2( sect_width, sect_width) )
	$AnalogClock.init(config, sect_width/2, 9 )
	reset_pos()
	init_request_bg()

# change dark mode by time
var old_time_dict = Time.get_datetime_dict_from_system() # datetime dict
var old_minute_dict = Time.get_datetime_dict_from_system() # datetime dict
func _process(_delta: float) -> void:
	label_demo()
	rot_by_accel()
	main_animation.handle_animation()

	var time_now_dict = Time.get_datetime_dict_from_system()
	if old_minute_dict["minute"] != time_now_dict["minute"]:
		start_move_animation()
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
	$Calendar.rotation = rad

var key2fn = {
	KEY_ESCAPE:_on_button_esc_pressed,
	KEY_ENTER : _on_button_패널보이기_pressed,
	KEY_SPACE : _on_button_패널보이기_pressed,
	KEY_Z : start_move_animation,
}
func _on_button_esc_pressed() -> void:
	get_tree().quit()

func _on_button_패널보이기_pressed() -> void:
	패널보이기(true)
	$"Timer패널숨기기".start(3)

func _on_timer패널숨기기_timeout() -> void:
	패널보이기(false)

func 패널보이기(b :bool) -> void:
	$"왼쪽패널".visible = b
	$"오른쪽패널".visible = b

# esc to exit
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var fn = key2fn.get(event.keycode)
		if fn != null:
			fn.call()
		else:
			update_color_with_mode(not Global2d.dark_mode)

	elif event is InputEventMouseButton and event.is_pressed():
		update_color_with_mode(not Global2d.dark_mode)


var bg_request :MyHTTPRequest
func init_request_bg()->void:
	bg_request = MyHTTPRequest.new(
		config.base_url + config.background_file,
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
	$Calendar.update_color()
	$AnalogClock.update_color()

func update_color_with_mode(darkmode :bool)->void:
	Global2d.set_dark_mode(darkmode)
	$Calendar.update_color()
	$AnalogClock.update_color()
