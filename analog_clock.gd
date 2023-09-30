extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var timeNowDict = Time.get_datetime_dict_from_system()
	$Panel/SecondHand.rotation = second2degree(timeNowDict["second"])
	$Panel/MinuteHand.rotation = minute2degree(timeNowDict["minute"]) + second2degree(timeNowDict["second"]) / 60
	$Panel/HourHand.rotation = hour2degree(timeNowDict["hour"]) + minute2degree(timeNowDict["minute"]) /60

func second2degree(sec)->float:
	return 2.0*PI/60.0*sec

func minute2degree(min)->float:
	return 2.0*PI/60.0*min

func hour2degree(hour)->float:
	return 2.0*PI/12.0*hour
