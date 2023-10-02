extends Node

const weekdaystring = ["일","월","화","수","목","금","토"]
const weekdayColorList = [
	Color.RED,  # sunday
	Color.WHITE,  # monday
	Color.WHITE,
	Color.WHITE,
	Color.WHITE,
	Color.WHITE,
	Color.BLUE,  # saturday
]

const HandDict = {
	"hour" : {
		"color" :Color.CYAN,
		"width" : 20,
		"height" : 330,
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

func set_font_shadow_darken(o, fontcolor :Color,offset):
	o.add_theme_color_override("font_color", fontcolor )
	o.add_theme_color_override("font_shadow_color", fontcolor.darkened(0.5) )
	o.add_theme_constant_override("shadow_offset_x",offset)
	o.add_theme_constant_override("shadow_offset_y",offset)
