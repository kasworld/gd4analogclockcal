extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.set_font_shadow_darken($LabelDate, Global.datelabelColor)
	_on_timer_timeout()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var oldDateUpdate = {"day":0} # datetime dict
func _on_timer_timeout() -> void:
	var timeNowDict = Time.get_datetime_dict_from_system()
	if oldDateUpdate["day"] != timeNowDict["day"]:
		oldDateUpdate = timeNowDict
		$LabelDate.text = "%04d-%02d-%02d %s" % [
			timeNowDict["year"] , timeNowDict["month"] ,timeNowDict["day"],
			Global.weekdaystring[ timeNowDict["weekday"]]
			]
