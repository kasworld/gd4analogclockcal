extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var calw = 1920-1080
	$Calendar.position = Vector2(1080+calw/2, 1080 - calw/2 )


# Called every frame. 'delta' is the elapsed time since the previous frame.
var oldvt = Vector2(0,-100)
func _process(delta: float) -> void:
	var vt = Input.get_accelerometer()
	if  vt != Vector3.ZERO :
		oldvt = (Vector2(vt.x,vt.y) + oldvt).normalized() *100
		var rad = oldvt.angle_to(Vector2(0,-1))
#		oldrad = (rad + oldrad) /2
		$AnalogClock.rotation = rad
		$TimeLabel.rotation = rad
		$Calendar.rotation = rad


#	var ms = Time.get_unix_time_from_system()
#	ms = ms - int(ms)
#	var timeNowDict = Time.get_datetime_dict_from_system()
#	$AnalogClock.rotation = -( second2rad(timeNowDict["second"]) + ms2rad(ms) )

func ms2rad(ms)->float:
	return 2.0*PI/60*ms

func second2rad(sec)->float:
	return 2.0*PI/60.0*sec
