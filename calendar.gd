extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_calendar_labels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

const weekdaystring = ["일","월","화","수","목","금","토"]
const weekdayColorList = [
	Color.RED,  # sunday
	Color.BLACK,  # monday
	Color.BLACK,
	Color.BLACK,
	Color.BLACK,
	Color.BLACK,
	Color.BLUE,  # saturday
]

func setfontshadow(o, fontcolor,offset):
	o.add_theme_color_override("font_color", fontcolor )
	o.add_theme_color_override("font_shadow_color", fontcolor.lightened(0.5) )
	o.add_theme_constant_override("shadow_offset_x",offset)
	o.add_theme_constant_override("shadow_offset_y",offset)

var calendar_labels = []
func init_calendar_labels():
	# prepare calendar
	for _i in range(7): # week title + 6 week
		var ln = []
		for j in weekdaystring.size():
			var lb = Label.new()
			lb.text = weekdaystring[j]
			lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			lb.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
			lb.vertical_alignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER
			setfontshadow(lb, weekdayColorList[j], 6)
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
			var co = weekdayColorList[wd]
			if dayIndexDict["month"] != todayDict["month"]:
				co = co.lightened(0.5)
			elif dayIndexDict["day"] == todayDict["day"]:
				co = Color.GREEN
			curLabel.add_theme_color_override("font_color",  co )
			curLabel.add_theme_color_override("font_shadow_color",  co.lightened(0.5) )
			dayIndex += 24*60*60

var oldDateUpdate = {"day":0} # datetime dict
func _on_timer_timeout() -> void:
	var timeNowDict = Time.get_datetime_dict_from_system()

	# date changed, update datelabel, calendar
	if oldDateUpdate["day"] != timeNowDict["day"]:
		oldDateUpdate = timeNowDict
		updateCalendar()
