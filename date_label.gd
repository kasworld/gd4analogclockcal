extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.set_font_shadow_offset($LabelDate, Global.datelabelColor)
	_on_timer_timeout()

var oldDateUpdate = {"day":0} # datetime dict
func _on_timer_timeout() -> void:
	var timeNowDict = Time.get_datetime_dict_from_system()
	if oldDateUpdate["day"] != timeNowDict["day"]:
		oldDateUpdate = timeNowDict
		$LabelDate.text = "%04d-%02d-%02d %s" % [
			timeNowDict["year"] , timeNowDict["month"] ,timeNowDict["day"],
			Global.weekdaystring[ timeNowDict["weekday"]]
			]
