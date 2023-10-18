extends Node2D

var vp_size :Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vp_size = get_viewport_rect().size
	var calw = vp_size.x-vp_size.y
	$Calendar.position = Vector2(vp_size.y+calw/2, vp_size.y /2 )
	$DateLabel.position = Vector2(vp_size.y /2, vp_size.y/2 )
	$TimeLabel.position = Vector2(vp_size.y /2, vp_size.y/2 )

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
