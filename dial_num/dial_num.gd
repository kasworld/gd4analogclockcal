extends Node2D

class_name DialNum

enum NumberType {None, Hour,Minute,Degree}

var radius :float
var font_size :float
var outline_w :int
var type :NumberType
var colorkey :String

func init(
		aradius :float = 10.0,
		afont_size :float = 1.0,
		aoutline_w :int = 4,
		atype :NumberType = NumberType.Hour,
		acolorkey = "dial_num",
	)->void:
	radius = aradius
	font_size = afont_size
	outline_w = aoutline_w
	type = atype
	colorkey = acolorkey

func update_color()->void:
	queue_redraw()

func _draw() -> void:
	draw_num( )

func draw_num()->void:
	var letter_size = font_size
	var letter_pos_r = radius
	match type:
		NumberType.Hour:
			for i in range(1,13):
				var rad = deg_to_rad( -i*(360.0/12.0) +180)
				draw_letter(rad,letter_pos_r, letter_size, i)
		NumberType.Minute:
			for i in range(0,60,5):
				var rad = deg_to_rad( -i*(360.0/60.0) +180)
				draw_letter(rad,letter_pos_r, letter_size, i)
		NumberType.Degree:
			for i in range(0,360,30):
				var rad = deg_to_rad( -i*(360.0/360.0) +180)
				draw_letter(rad,letter_pos_r, letter_size, i)

func draw_letter(rad :float, r :float, fsize :float, i :int)->void:
	var t = "%d" % i
	var pos = make_pos_by_rad_r(rad, r)
	var offset = Vector2(-fsize/3.5*t.length(),fsize/3)
	var co = Global2d.colors[colorkey]
	if outline_w == 0:
		draw_string(Global2d.font, pos+offset, t, HORIZONTAL_ALIGNMENT_CENTER, -1, fsize, co )
	else:
		draw_string_outline(Global2d.font, pos+offset, t, HORIZONTAL_ALIGNMENT_CENTER, -1, fsize,outline_w, co )

func draw_cross(p :Vector2, l:float, co :Color)->void:
	draw_line(p + Vector2(-l/2,0),p + Vector2(l/2,0), co,-1 )
	draw_line(p + Vector2(0,-l/2),p + Vector2(0,l/2), co,-1 )

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)
