extends Node2D

class_name DialBar

enum BarAlign {None, In,Mid,Out}

var radius :float
var thick :float
var align :BarAlign
var colorkey :String
var dial_bars :PackedVector2Array =[]

func init(
		aradius :float = 10.0,
		athick :float = 1.0,
		aalign :BarAlign = BarAlign.In,
		acolorkey = "dial_line",
	)->void:
	radius = aradius
	thick = athick
	align = aalign
	colorkey = acolorkey
	make_dial_bars()

func update_color()->void:
	queue_redraw()

func _draw() -> void:
	var w = thick
	if w < 1 :
		w = -1
	draw_multiline(dial_bars,Global2d.colors[colorkey], w)

func make_dial_bars()->void:
	var r = radius
	for i in range(0,360):
		var rad = deg_to_rad(-i+180)
		var offset :float = 0
		if i % 30 == 0 :
			offset = r*0.08
		elif i % 6 == 0 :
			offset = r*0.04
		else :
			offset = r*0.02
		match align:
			BarAlign.In :
				dial_bars.append_array([ make_pos_by_rad_r(rad,r-offset),make_pos_by_rad_r(rad,r) ])
			BarAlign.Mid :
				dial_bars.append_array([ make_pos_by_rad_r(rad,r-offset/2),make_pos_by_rad_r(rad,r+offset/2) ])
			BarAlign.Out :
				dial_bars.append_array([ make_pos_by_rad_r(rad,r),make_pos_by_rad_r(rad,r+offset) ])

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)
