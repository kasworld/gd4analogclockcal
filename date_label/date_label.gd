extends Node2D

func init(rt :Rect2, co1 :Color, co2 :Color)->void:
	$LabelDate.size = rt.size
	$LabelDate.position = rt.position
	$LabelDate.label_settings = Global.make_label_setting(rt.size.y*0.9, co1, co2)
	_on_timer_timeout()

func update_color()->void:
	var co = Global.colors.datelabel
	Global.set_label_color($LabelDate, co, Global.make_shadow_color(co))

var old_time_dict = {"day":0} # datetime dict
func _on_timer_timeout() -> void:
	var time_now_dict = Time.get_datetime_dict_from_system()
	if old_time_dict["day"] != time_now_dict["day"]:
		old_time_dict = time_now_dict
		$LabelDate.text = "%04d-%02d-%02d %s" % [
			time_now_dict["year"] , time_now_dict["month"] ,time_now_dict["day"],
			Global.weekdaystring[ time_now_dict["weekday"]]
			]
