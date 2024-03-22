extends Node2D

class_name AnalogDial

var dfont = preload("res://HakgyoansimBareondotumR.ttf")

var dial_lines :PackedVector2Array =[]
var line_thick :float = 2
var clock_R :float

func make_dial_lines(r :float)->void:
	for i in range(0,360):
		var rad = deg_to_rad(i+180)
		var r1 :float
		if i == 0:
			r1 = r*0.9
		elif i % 90 == 0:
			r1 = r*0.92
		elif i % 30 == 0 :
			r1 = r*0.94
		elif i % 6 == 0 :
			r1 = r*0.96
		else :
			r1 = r*0.98
		dial_lines.append_array([ make_pos_by_rad_r(rad,r1),make_pos_by_rad_r(rad,r) ])

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)

func init(r:float)->void:
	clock_R = r
	make_dial_lines(clock_R)
	line_thick = clock_R/200

func update_color()->void:
	queue_redraw()

func _draw() -> void:
	draw_multiline(dial_lines,Global2d.colors.dial_1, line_thick)
	for i in range(1,13):
		draw_hour_letter(clock_R,i)

func draw_cross(p :Vector2, l:float, co :Color)->void:
	draw_line(p + Vector2(-l/2,0),p + Vector2(l/2,0), co,-1 )
	draw_line(p + Vector2(0,-l/2),p + Vector2(0,l/2), co,-1 )

func draw_hour_letter(r :float,  i :int)->void:
	var rad = deg_to_rad( -i*30.0 -180)
	var fsize = r/10
	var t = "%d" % i
	var pos = make_pos_by_rad_r(rad, r*0.87)
	#draw_cross(pos,fsize*2, Global2d.colors.dial_1)
	var offset = Vector2(-fsize/3.5*t.length(),fsize/3)
	#draw_cross(pos+offset,fsize*2, Global2d.colors.dial_1)
	#var default_font = ThemeDB.fallback_font
	draw_string(dfont, pos+offset, t, HORIZONTAL_ALIGNMENT_CENTER, -1,  fsize, Global2d.colors.dial_num )
