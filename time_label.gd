extends Node2D

func setfontshadow(o, fontcolor,offset):
	o.add_theme_color_override("font_color", fontcolor )
	o.add_theme_color_override("font_shadow_color", fontcolor.lightened(0.5) )
	o.add_theme_constant_override("shadow_offset_x",offset)
	o.add_theme_constant_override("shadow_offset_y",offset)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setfontshadow($LabelTime, Color.BLACK, 4)
	_on_timer_timeout()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var oldDateUpdate = {"day":0} # datetime dict
func _on_timer_timeout() -> void:
	var timeNowDict = Time.get_datetime_dict_from_system()
	$LabelTime.text = "%02d:%02d:%02d" % [timeNowDict["hour"] , timeNowDict["minute"] ,timeNowDict["second"]  ]
