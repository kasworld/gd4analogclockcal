extends Node2D

class_name AnalogDial

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

