extends Node

const weekdaystring = ["일","월","화","수","목","금","토"]
var weekdayColorInfo = [
	[Color.LIGHT_CORAL, Color.LIGHT_CORAL.darkened(0.5), 3],  # sunday
	[Color.WHITE_SMOKE, Color.WHITE_SMOKE.darkened(0.5), 3],  # monday
	[Color.WHITE_SMOKE, Color.WHITE_SMOKE.darkened(0.5), 3],
	[Color.WHITE_SMOKE, Color.WHITE_SMOKE.darkened(0.5), 3],
	[Color.WHITE_SMOKE, Color.WHITE_SMOKE.darkened(0.5), 3],
	[Color.WHITE_SMOKE, Color.WHITE_SMOKE.darkened(0.5), 3],
	[Color.SKY_BLUE, Color.SKY_BLUE.darkened(0.5), 3],  # saturday
]

var timelabelColor = [Color.WHITE_SMOKE,Color.WHITE_SMOKE.darkened(0.5),4]
var datelabelColor = [Color.WHITE_SMOKE,Color.WHITE_SMOKE.darkened(0.5),4]
var todayColor = Color.GOLD

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

func set_font_shadow_offset(o, fontinfo ):
	o.add_theme_color_override("font_color", fontinfo[0] )
	o.add_theme_color_override("font_shadow_color", fontinfo[1] )
	o.add_theme_constant_override("shadow_offset_x",fontinfo[2])
	o.add_theme_constant_override("shadow_offset_y",fontinfo[2])

func set_font_color_shasow(o, co, shco):
	o.add_theme_color_override("font_color", co )
	o.add_theme_color_override("font_shadow_color", shco )

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
