extends Node2D

class_name AnalogDial

var dial_lines :PackedVector2Array =[]
var line_thick :float = 2
var clock_R :float

enum DrawNumMode {Hour,Minute,Degree}
var draw_num_mode :DrawNumMode

func init(r:float, dnm :DrawNumMode = DrawNumMode.Hour)->void:
	clock_R = r
	draw_num_mode = dnm
	make_dial_lines(clock_R)
	line_thick = clock_R/200

func make_dial_lines(r :float)->void:
	for i in range(0,360):
		var rad = deg_to_rad(i+180)
		var r1 :float
		if i % 30 == 0 :
			r1 = r*0.94
		elif i % 6 == 0 :
			r1 = r*0.96
		else :
			r1 = r*0.98
		dial_lines.append_array([ make_pos_by_rad_r(rad,r1),make_pos_by_rad_r(rad,r) ])

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)

func update_color()->void:
	queue_redraw()

func _draw() -> void:
	draw_multiline(dial_lines,Global2d.colors.dial_1, line_thick)
	match draw_num_mode:
		DrawNumMode.Hour:
			for i in range(1,13):
				draw_hour_letter(clock_R,i)
		DrawNumMode.Minute:
			for i in range(0,60,5):
				draw_minute_letter(clock_R,clock_R/10, i)
		DrawNumMode.Degree:
			for i in range(0,360,30):
				draw_degree_letter(clock_R,clock_R/10, i)

func draw_cross(p :Vector2, l:float, co :Color)->void:
	draw_line(p + Vector2(-l/2,0),p + Vector2(l/2,0), co,-1 )
	draw_line(p + Vector2(0,-l/2),p + Vector2(0,l/2), co,-1 )

func draw_hour_letter(r :float, i :int)->void:
	var rad = deg_to_rad( -i*(360.0/12.0) -180)
	var fsize = r/10
	var t = "%d" % i
	var pos = make_pos_by_rad_r(rad, r*0.87)
	var offset = Vector2(-fsize/3.5*t.length(),fsize/3)
	draw_string(Global2d.font, pos+offset, t, HORIZONTAL_ALIGNMENT_CENTER, -1,  fsize, Global2d.colors.dial_num )

func draw_minute_letter(r :float, fsize :float,  i :int)->void:
	var rad = deg_to_rad( -i*(360.0/60.0) -180)
	var t = "%d" % i
	var pos = make_pos_by_rad_r(rad, r*0.87)
	var offset = Vector2(-fsize/3.5*t.length(),fsize/3)
	draw_string(Global2d.font, pos+offset, t, HORIZONTAL_ALIGNMENT_CENTER, -1,  fsize, Global2d.colors.dial_num )

func draw_degree_letter(r :float, fsize :float,  i :int)->void:
	var rad = deg_to_rad( -i*(360.0/360.0) -180)
	var t = "%d" % i
	var pos = make_pos_by_rad_r(rad, r*0.87)
	var offset = Vector2(-fsize/3.5*t.length(),fsize/3)
	draw_string(Global2d.font, pos+offset, t, HORIZONTAL_ALIGNMENT_CENTER, -1,  fsize, Global2d.colors.dial_num )
