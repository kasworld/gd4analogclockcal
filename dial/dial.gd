extends Node2D

class_name Dial

enum NumberType {Hour,Minute,Degree}
enum LineAlign {In,Mid,Out}

var dial_lines :PackedVector2Array =[]

var main_radius :float
var line_thick_rate :float
var line_align :LineAlign
var nums_font_size_rate :float
var nums_radius_rate :float
var num_outline_w :int
var number_type :NumberType

func init(r:float, lntk :float = 0.004, lnan :LineAlign = LineAlign.In, numrate:float = 0.9, ftrate :float = 0.09, numoutline :int = 4, dnm :NumberType = NumberType.Hour)->void:
	main_radius = r
	line_thick_rate = lntk
	line_align = lnan
	nums_radius_rate = numrate
	nums_font_size_rate = ftrate
	num_outline_w = numoutline
	number_type = dnm
	make_dial_lines(main_radius)

func make_dial_lines(r :float)->void:
	for i in range(0,360):
		var rad = deg_to_rad(i+180)
		var offset :float = 0
		if i % 30 == 0 :
			offset = r*0.06
		elif i % 6 == 0 :
			offset = r*0.04
		else :
			offset = r*0.02
		match line_align:
			LineAlign.In :
				dial_lines.append_array([ make_pos_by_rad_r(rad,r-offset),make_pos_by_rad_r(rad,r) ])
			LineAlign.Mid :
				dial_lines.append_array([ make_pos_by_rad_r(rad,r-offset/2),make_pos_by_rad_r(rad,r+offset/2) ])
			LineAlign.Out :
				dial_lines.append_array([ make_pos_by_rad_r(rad,r),make_pos_by_rad_r(rad,r+offset) ])

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)

func update_color()->void:
	queue_redraw()

func _draw() -> void:
	var w = main_radius* line_thick_rate
	if w < 1 :
		w = -1
	draw_multiline(dial_lines,Global2d.colors.dial_1, w)
	match number_type:
		NumberType.Hour:
			for i in range(1,13):
				var rad = deg_to_rad( -i*(360.0/12.0) -180)
				draw_letter(rad,nums_radius_rate *main_radius, main_radius*nums_font_size_rate, i)
		NumberType.Minute:
			for i in range(0,60,5):
				var rad = deg_to_rad( -i*(360.0/60.0) -180)
				draw_letter(rad,nums_radius_rate *main_radius, main_radius*nums_font_size_rate, i)
		NumberType.Degree:
			for i in range(0,360,30):
				var rad = deg_to_rad( -i*(360.0/360.0) -180)
				draw_letter(rad,nums_radius_rate *main_radius, main_radius*nums_font_size_rate, i)

func draw_letter(rad :float, r :float, fsize :float, i :int)->void:
	var t = "%d" % i
	var pos = make_pos_by_rad_r(rad, r)
	var offset = Vector2(-fsize/3.5*t.length(),fsize/3)
	if num_outline_w == 0:
		draw_string(Global2d.font, pos+offset, t, HORIZONTAL_ALIGNMENT_CENTER, -1,  fsize, Global2d.colors.dial_num )
	else:
		draw_string_outline(Global2d.font, pos+offset, t, HORIZONTAL_ALIGNMENT_CENTER, -1,  fsize,num_outline_w, Global2d.colors.dial_num )

func draw_cross(p :Vector2, l:float, co :Color)->void:
	draw_line(p + Vector2(-l/2,0),p + Vector2(l/2,0), co,-1 )
	draw_line(p + Vector2(0,-l/2),p + Vector2(0,l/2), co,-1 )
