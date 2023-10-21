extends Node

# for calendar ans date_label
const weekdaystring = ["일","월","화","수","목","금","토"]

# for calendar
var weekdayColorInfo = [
	[Color.LIGHT_CORAL, Color.LIGHT_CORAL.darkened(0.5)],  # sunday
	[Color.WHITE_SMOKE, Color.WHITE_SMOKE.darkened(0.5)],  # monday
	[Color.WHITE_SMOKE, Color.WHITE_SMOKE.darkened(0.5)],
	[Color.WHITE_SMOKE, Color.WHITE_SMOKE.darkened(0.5)],
	[Color.WHITE_SMOKE, Color.WHITE_SMOKE.darkened(0.5)],
	[Color.WHITE_SMOKE, Color.WHITE_SMOKE.darkened(0.5)],
	[Color.SKY_BLUE, Color.SKY_BLUE.darkened(0.5)],  # saturday
]
var timelabelColor = [Color.WHITE_SMOKE,Color.WHITE_SMOKE.darkened(0.5)]
var datelabelColor = [Color.WHITE_SMOKE,Color.WHITE_SMOKE.darkened(0.5)]
var todayColor = Color.GOLD

# for analog clock
var HandDict = {
	"hour" : {
		"color" :Color.SKY_BLUE,
		"width" : 1.0/25,
		"height" : 0.7,
	},
	"hour2" : {
		"color" :Color.SKY_BLUE.darkened(0.5),
		"width" : 1.0/100,
		"height" : 0.65,
	},
	"minute" : {
		"color" :Color.PALE_GREEN,
		"width" : 1.0/50,
		"height" : 0.9,
	},
	"second" : {
		"color" :Color.LIGHT_CORAL,
		"width" : 1.0/100,
		"height" : 1.0,
	}
}

# common functions

func make_label_setting(font_size :float , co1 :Color, co2 :Color)->LabelSettings:
	var label_settings = LabelSettings.new()
	label_settings.font_color = co1
	label_settings.font_size = font_size
	label_settings.shadow_color = co2
	label_settings.shadow_offset = Vector2( font_size /20, font_size /20)
	return label_settings

func new_circle_fill(p :Vector2, r :float, co:Color) -> Polygon2D :
	var rtn = Polygon2D.new()
	var pv2a : PackedVector2Array = []
	for i in 360 :
		var v2 = Vector2(sin(i*2*PI/360)*r, cos(i*2*PI/360)*r) + p
		pv2a.append(v2)
	rtn.polygon = pv2a
	rtn.color = co
	return rtn

func new_circle(p :Vector2, r :float, co :Color, w :float) -> Line2D :
	var rtn = Line2D.new()
	for i in 361 :
		var v2 = Vector2(sin(i*2*PI/360)*r, cos(i*2*PI/360)*r) + p
		rtn.add_point(v2)
	rtn.default_color = co
	rtn.width = w
	return rtn
