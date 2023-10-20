extends Node2D

func init(w :float,h :float):
	$LabelTime.size.x = w
	$LabelTime.size.y = h
	$LabelTime.position.x = -w/2
	$LabelTime.position.y = h/2
	var fi = Global.timelabelColor
	$LabelTime.label_settings = Global.make_label_setting(h, fi[0], fi[1])
	_on_timer_timeout()


var oldDateUpdate = {"day":0} # datetime dict
func _on_timer_timeout() -> void:
	var timeNowDict = Time.get_datetime_dict_from_system()
	$LabelTime.text = "%02d:%02d:%02d" % [timeNowDict["hour"] , timeNowDict["minute"] ,timeNowDict["second"]  ]
