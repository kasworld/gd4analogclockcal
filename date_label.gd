extends Node2D


func init(x :float,y :float, w :float,h :float):
	$LabelDate.size.x = w
	$LabelDate.size.y = h
	$LabelDate.position.x = x
	$LabelDate.position.y = y
	var fi = Global.datelabelColor
	$LabelDate.label_settings = Global.make_label_setting(h, fi[0], fi[1])
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
