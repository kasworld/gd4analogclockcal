extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.get_accelerometer() != Vector3.ZERO :
		pass
#	var ms = Time.get_unix_time_from_system()
#	ms = ms - int(ms)
#	var timeNowDict = Time.get_datetime_dict_from_system()
#	$AnalogClock.rotation = -( second2rad(timeNowDict["second"]) + ms2rad(ms) )

func ms2rad(ms)->float:
	return 2.0*PI/60*ms

func second2rad(sec)->float:
	return 2.0*PI/60.0*sec
