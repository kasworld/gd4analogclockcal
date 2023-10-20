extends Node2D

var vp_size :Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_http()
	vp_size = get_viewport_rect().size
	var calw = vp_size.x-vp_size.y
	$Calendar.init(-calw/2, -calw/2, calw, calw)
	$Calendar.position = Vector2(vp_size.y+calw/2, vp_size.y/2 )

	$DateLabel.init( -vp_size.x/4/2, -vp_size.y/8*1.5,  vp_size.x/4, vp_size.y/8)
	$DateLabel.position = Vector2(vp_size.y/2, vp_size.y/2 )

	$TimeLabel.init(-vp_size.x/2/2, vp_size.y/6/2,  vp_size.x/2, vp_size.y/6)
	$TimeLabel.position = Vector2(vp_size.y/2, vp_size.y/2 )

# Called every frame. 'delta' is the elapsed time since the previous frame.
var oldvt = Vector2(0,-100)
func _process(_delta: float) -> void:
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
	$DateLabel.rotation = rad
	$Calendar.rotation = rad

# esc to exit
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()

func init_http():
	var ccr = ClockCalRouter.new()
	ccr.helloed.connect(helloed)
	var server = HttpServer.new()
	server.register_router("/", ccr)
	add_child(server)
	server.start()

func helloed():
	print_debug("helloed")
