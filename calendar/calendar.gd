extends Node2D

class_name Calendar2

var csize :Vector2
func init(cs :Vector2)->void:
	csize = cs
	queue_redraw()

func update_color()->void:
	queue_redraw()

func draw_calendar()->void:
	var fw = csize.x/7
	var fh = csize.y/8
	var tz = Time.get_time_zone_from_system()
	var today = int(Time.get_unix_time_from_system()) +tz["bias"]*60
	var today_dict = Time.get_date_dict_from_unix_time(today)
	var day_index = today - (7 + today_dict["weekday"] )*24*60*60 #datetime.timedelta(days=(-today.weekday() - 7))

	var offset = Vector2(0,fh*0.7)

	var text_ym = "%4d년 %2d월" % [today_dict["year"] , today_dict["month"]]
	draw_string(Global2d.font, Vector2(-csize.x/3,-csize.y/2) +offset, text_ym, HORIZONTAL_ALIGNMENT_CENTER, -1,  fh, Global2d.colors.datelabel )

	for wd in Global2d.weekdaystring.size():
		var week = 1
		var co = Global2d.colors.weekday[wd]
		var fsize = fh*0.9
		var today_adj = Vector2(0,0)
		var text =  Global2d.weekdaystring[wd]
		if wd == today_dict["weekday"] :
			co = Global2d.colors.today
			fsize = fh *1.2
			today_adj = Vector2(-fsize*0.1, fsize*0.08)
		var pos = Vector2(fw*wd,fh*week) - csize/2 +offset+Vector2(fh/10 ,0) + today_adj
		draw_string(Global2d.font, pos , text, HORIZONTAL_ALIGNMENT_CENTER, -1,  fsize, co )

	for week in range(2,8):
		for wd in range(7):
			var day_index_dict = Time.get_date_dict_from_unix_time(day_index)
			var co = Global2d.colors.weekday[wd]
			var fsize = fh*0.9
			var today_adj = Vector2(0,0)
			var text = "%2d" % day_index_dict["day"]
			if day_index_dict["month"] != today_dict["month"]:
				co = Global2d.make_shadow_color(co)
			elif day_index_dict["day"] == today_dict["day"]:
				co = Global2d.colors.today
				fsize = fh*1.2
				today_adj = Vector2(-fsize*0.08 * text.length(), fsize*0.08)
			var pos = Vector2(fw*wd,fh*week) - csize/2 +offset + today_adj
			draw_string(Global2d.font, pos , text, HORIZONTAL_ALIGNMENT_CENTER, -1,  fsize, co )
			day_index += 24*60*60

func _draw() -> void:
	draw_calendar()

var old_time_dict = {"day":0} # datetime dict
func _on_timer_timeout() -> void:
	var time_now_dict = Time.get_datetime_dict_from_system()

	# date changed, update datelabel, calendar
	if old_time_dict["day"] != time_now_dict["day"]:
		old_time_dict = time_now_dict
		queue_redraw()

