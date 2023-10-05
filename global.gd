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
