extends Node

const weekdaystring = ["일","월","화","수","목","금","토"]
var weekdayColorInfo = [
	[Color.MAGENTA, Color.MAGENTA.darkened(0.5), 3],  # sunday
	[Color.WHITE, Color.WHITE.darkened(0.5), 3],  # monday
	[Color.WHITE, Color.WHITE.darkened(0.5), 3],
	[Color.WHITE, Color.WHITE.darkened(0.5), 3],
	[Color.WHITE, Color.WHITE.darkened(0.5), 3],
	[Color.WHITE, Color.WHITE.darkened(0.5), 3],
	[Color.CYAN, Color.CYAN.darkened(0.5), 3],  # saturday
]

var timelabelColor = [Color.WHITE,Color.WHITE.darkened(0.5),4]
var datelabelColor = [Color.WHITE,Color.WHITE.darkened(0.5),4]

var HandDict = {
	"hour" : {
		"color" :Color.CYAN,
		"width" : 20,
		"height" : 330,
	},
	"hour2" : {
		"color" :Color.CYAN.darkened(0.5),
		"width" : 6,
		"height" : 300,
	},
	"minute" : {
		"color" :Color.YELLOW,
		"width" : 10,
		"height" : 440,
	},
	"second" : {
		"color" :Color.MAGENTA,
		"width" : 6,
		"height" : 600,
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
