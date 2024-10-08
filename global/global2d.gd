extends Node

# for calendar ans date_label
const weekdaystring = ["일","월","화","수","목","금","토"]

# for calendar
var colors_dark = {
	weekday = [
		Color.RED.lightened(0.5),  # sunday
		Color.WHITE,  # monday
		Color.WHITE,
		Color.WHITE,
		Color.WHITE,
		Color.WHITE,
		Color.BLUE.lightened(0.5),  # saturday
	],
	today = Color.GREEN,
	timelabel = Color.WHITE,
	datelabel = Color.WHITE,
	infolabel = Color.WHITE,
	default_clear = Color.BLACK,

	# analog clock
	hour1 = Color.BLUE.lightened(0.5),
	hour2 = Color.BLUE,
	minute = Color.GREEN,
	second = Color.RED.lightened(0.5),
	center_circle1 = Color.GOLD,
	center_circle2 = Color.YELLOW,
	dial_num = Color.DARK_GOLDENROD,
	dial_line = Color.DARK_GOLDENROD,
}
var colors_light = 	{
	weekday = [
		Color.RED,   # sunday
		Color.BLACK,   # monday
		Color.BLACK,
		Color.BLACK,
		Color.BLACK,
		Color.BLACK,
		Color.BLUE,   # saturday
	],
	today = Color.GREEN.darkened(0.5),
	timelabel = Color.BLACK,
	datelabel = Color.BLACK,
	infolabel = Color.BLACK,
	default_clear = Color.WHITE,
	# analog clock
	hour1 = Color.BLUE,
	hour2 = Color.BLUE.lightened(0.5),
	minute = Color.GREEN.darkened(0.5),
	second = Color.RED,
	center_circle1 = Color.GOLDENROD,
	center_circle2 = Color.DARK_GOLDENROD,
	dial_num = Color.GOLD,
	dial_line = Color.GOLD,
}
var colors = colors_dark

var font = preload("res://HakgyoansimBareondotumR.ttf")

# common functions
var dark_mode = true
func set_dark_mode(b :bool)->void:
	dark_mode = b
	if dark_mode :
		colors = colors_dark
	else :
		colors = colors_light
	RenderingServer.set_default_clear_color(colors.default_clear)

func make_shadow_color(co :Color)->Color:
	if dark_mode:
		return co.darkened(0.5)
	else :
		return co.lightened(0.5)

func make_label_setting(font_size :float , co1 :Color)->LabelSettings:
	var label_settings = LabelSettings.new()
	label_settings.font = font
	label_settings.font_color = co1
	label_settings.font_size = font_size
	return label_settings

func calc_font_offset_vector2(font_size :float)->Vector2:
	var offset = log(font_size)
	offset = clampf(offset, 1, 6)
	return Vector2(offset,offset)

func set_label_font_size(lb :Label, font_size :float)->void:
	lb.label_settings.font_size = font_size
	var offset = calc_font_offset_vector2(font_size)
	lb.label_settings.shadow_offset = offset

func new_circle_fill(p :Vector2, r :float, co:Color) -> Polygon2D :
	var rtn = Polygon2D.new()
	var pv2a : PackedVector2Array = []
	for i in 360 :
		var v2 = Vector2(sin(i*2*PI/360)*r, cos(i*2*PI/360)*r) + p
		pv2a.append(v2)
	rtn.polygon = pv2a
	rtn.color = co
	rtn.antialiased = true
	return rtn

func new_circle(p :Vector2, r :float, co :Color, w :float) -> Line2D :
	var rtn = Line2D.new()
	for i in 361 :
		var v2 = Vector2(sin(i*2*PI/360)*r, cos(i*2*PI/360)*r) + p
		rtn.add_point(v2)
	rtn.default_color = co
	rtn.width = w
	rtn.antialiased = true
	return rtn
