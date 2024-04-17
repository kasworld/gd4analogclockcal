extends Node2D

class_name Dial

enum BarAlign {None, In,Mid,Out}
enum NumberType {None, Hour,Minute,Degree}

class BarParams:
	var radius :float
	var thick :float
	var align :BarAlign
	var colorkey :String
	func _init(
		radius :float = 10.0,
		thick :float = 1.0,
		align :BarAlign = BarAlign.In,
		colorkey = "dial_line",
	) -> void:
		self.radius = radius
		self.thick = thick
		self.align = align
		self.colorkey = colorkey

class NumberParams :
	var radius :float
	var font_size :float
	var outline_w :int
	var type :NumberType
	var colorkey :String
	func _init(
		radius :float = 10.0,
		font_size :float = 1.0,
		outline_w :int = 4,
		type :NumberType = NumberType.Hour,
		colorkey = "dial_num",
	)->void:
		self.radius = radius
		self.font_size = font_size
		self.outline_w = outline_w
		self.type = type
		self.colorkey = colorkey

var dial_bars :PackedVector2Array =[]
var bar_params = BarParams.new()
var number_params = NumberParams.new()

func init(lparam = bar_params, nparm = number_params)->void:
	bar_params = lparam
	number_params = nparm
	make_dial_bars()

func update_color()->void:
	queue_redraw()

func _draw() -> void:
	var w = bar_params.thick
	if w < 1 :
		w = -1
	draw_multiline(dial_bars,Global2d.colors[bar_params.colorkey], w)
	draw_num( )

func make_dial_bars()->void:
	var r = bar_params.radius
	for i in range(0,360):
		var rad = deg_to_rad(-i+180)
		var offset :float = 0
		if i % 30 == 0 :
			offset = r*0.06
		elif i % 6 == 0 :
			offset = r*0.04
		else :
			offset = r*0.02
		match bar_params.align:
			BarAlign.In :
				dial_bars.append_array([ make_pos_by_rad_r(rad,r-offset),make_pos_by_rad_r(rad,r) ])
			BarAlign.Mid :
				dial_bars.append_array([ make_pos_by_rad_r(rad,r-offset/2),make_pos_by_rad_r(rad,r+offset/2) ])
			BarAlign.Out :
				dial_bars.append_array([ make_pos_by_rad_r(rad,r),make_pos_by_rad_r(rad,r+offset) ])

func draw_num()->void:
	var letter_size = number_params.font_size
	var letter_pos_r = number_params.radius
	match number_params.type:
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
	var co = Global2d.colors[number_params.colorkey]
	if number_params.outline_w == 0:
		draw_string(Global2d.font, pos+offset, t, HORIZONTAL_ALIGNMENT_CENTER, -1, fsize, co )
	else:
		draw_string_outline(Global2d.font, pos+offset, t, HORIZONTAL_ALIGNMENT_CENTER, -1, fsize,number_params.outline_w, co )

func draw_cross(p :Vector2, l:float, co :Color)->void:
	draw_line(p + Vector2(-l/2,0),p + Vector2(l/2,0), co,-1 )
	draw_line(p + Vector2(0,-l/2),p + Vector2(0,l/2), co,-1 )

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)
