extends Node2D

# 1+7x7 : year+month, weekdayname, 6 weeek
var calendar_labels = []

func init(csize :Vector2)->void:
	init_calendar_labels(csize)
	update_calendar()

func update_color()->void:
	var co = Global2d.colors.datelabel
	Global2d.set_label_color(calendar_labels[0], co, Global2d.make_shadow_color(co))

	for i in range(1,8): # week title + 6 week
		for j in Global2d.weekdaystring.size():
			co = Global2d.colors.weekday[j]
			Global2d.set_label_color(calendar_labels[i][j], co, Global2d.make_shadow_color(co))
	update_calendar()

func init_calendar_labels( csize :Vector2)->void:
	var fw = csize.x/7
	var fh = csize.y/8

	# date label
	var lb = Label.new()
	lb.text = "0000년00월"
	lb.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
	lb.vertical_alignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER
	var co = Global2d.colors.datelabel
	lb.label_settings = Global2d.make_label_setting(fh, co, Global2d.make_shadow_color(co))
	lb.position = Vector2(-csize.x/3,-csize.y/2)
	calendar_labels.append(lb)
	add_child(lb)

	# prepare calendar
	for i in range(1,8): # week title + 6 week
		var ln = []
		for j in Global2d.weekdaystring.size():
			lb = Label.new()
			lb.text =  Global2d.weekdaystring[j]
			#lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			lb.horizontal_alignment = HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER
			lb.vertical_alignment = VerticalAlignment.VERTICAL_ALIGNMENT_CENTER
			co = Global2d.colors.weekday[j]
			lb.label_settings = Global2d.make_label_setting(fh*0.8, co, Global2d.make_shadow_color(co))
			lb.position = Vector2(fw*j,fh*i) - csize/2
			ln.append(lb)
			add_child(lb)
		calendar_labels.append(ln)

func update_calendar()->void:
	var tz = Time.get_time_zone_from_system()
	var today = int(Time.get_unix_time_from_system()) +tz["bias"]*60
	var today_dict = Time.get_date_dict_from_unix_time(today)
	var day_index = today - (7 + today_dict["weekday"] )*24*60*60 #datetime.timedelta(days=(-today.weekday() - 7))

	calendar_labels[0].text = "%4d년 %2d월" % [today_dict["year"] , today_dict["month"]]

	for wd in range(7):
		var curLabel = calendar_labels[1][wd]
		var co = Global2d.colors.weekday[wd]
		if wd == today_dict["weekday"] :
			co = Global2d.colors.today
		Global2d.set_label_color(curLabel, co, Global2d.make_shadow_color(co))

	for week in range(2,8):
		for wd in range(7):
			var day_index_dict = Time.get_date_dict_from_unix_time(day_index)
			var curLabel = calendar_labels[week][wd]
			curLabel.text = "%2d" % day_index_dict["day"]
			var co = Global2d.colors.weekday[wd]
			if day_index_dict["month"] != today_dict["month"]:
				co = Global2d.make_shadow_color(co)
			elif day_index_dict["day"] == today_dict["day"]:
				co = Global2d.colors.today
			Global2d.set_label_color(curLabel, co, Global2d.make_shadow_color(co))
			day_index += 24*60*60

var old_time_dict = {"day":0} # datetime dict
func _on_timer_timeout() -> void:
	var time_now_dict = Time.get_datetime_dict_from_system()

	# date changed, update datelabel, calendar
	if old_time_dict["day"] != time_now_dict["day"]:
		old_time_dict = time_now_dict
		update_calendar()

