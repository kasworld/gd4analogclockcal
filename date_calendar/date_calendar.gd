extends Node2D

func init(rt :Rect2)->void:
	$VBoxContainer.size = rt.size
	$VBoxContainer.position = rt.position

	var co = Global.colors.datelabel
	$VBoxContainer/LabelDate.label_settings = Global.make_label_setting(rt.size.y/9, co, Global.make_shadow_color(co))

	$VBoxContainer/Calendar.init(Rect2(Vector2(0,rt.size.y/9), Vector2(rt.size.x, rt.size.y-rt.size.y/9) ) )

	_on_timer_timeout()

func update_color()->void:
	$VBoxContainer/Calendar.update_color()

var old_time_dict = {"day":0} # datetime dict
func _on_timer_timeout() -> void:
	var time_now_dict = Time.get_datetime_dict_from_system()

	# date changed, update datelabel, calendar
	if old_time_dict["day"] != time_now_dict["day"]:
		old_time_dict = time_now_dict
		$VBoxContainer/LabelDate.text = "%4d년 %2d월" % [
			time_now_dict["year"] , time_now_dict["month"]
			]
