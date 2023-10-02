extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_calendar_labels()
	updateCalendar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var calendar_labels = []
func init_calendar_labels():
	# prepare calendar
	for _i in range(7): # week title + 6 week
		var ln = []
		for j in Global.weekdaystring.size():
			var lb = Label.new()
			lb.text = Global.weekdaystring[j]
			lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			lb.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
			lb.vertical_alignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER
			Global.set_font_shadow_darken(lb, Global.weekdayColorList[j], 3)
			$GridCalendar.add_child(lb)
			ln.append(lb)
		calendar_labels.append(ln)

func updateCalendar():
	var tz = Time.get_time_zone_from_system()
	var today = int(Time.get_unix_time_from_system()) +tz["bias"]*60
	var todayDict = Time.get_date_dict_from_unix_time(today)
	var dayIndex = today - (7 + todayDict["weekday"] )*24*60*60 #datetime.timedelta(days=(-today.weekday() - 7))

	for week in range(6):
		for wd in range(7):
			var dayIndexDict = Time.get_date_dict_from_unix_time(dayIndex)
			var curLabel = calendar_labels[week+1][wd]
			curLabel.text = "%d" % dayIndexDict["day"]
			var co = Global.weekdayColorList[wd]
			if dayIndexDict["month"] != todayDict["month"]:
				co = co.darkened(0.5)
			elif dayIndexDict["day"] == todayDict["day"]:
				co = Color.GREEN
			curLabel.add_theme_color_override("font_color",  co )
			curLabel.add_theme_color_override("font_shadow_color",  co.darkened(0.5) )
			dayIndex += 24*60*60

var oldDateUpdate = {"day":0} # datetime dict
func _on_timer_timeout() -> void:
	var timeNowDict = Time.get_datetime_dict_from_system()

	# date changed, update datelabel, calendar
	if oldDateUpdate["day"] != timeNowDict["day"]:
		oldDateUpdate = timeNowDict
		updateCalendar()
