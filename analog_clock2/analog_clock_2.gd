extends Node2D

class_name AnalogClock2

var tz_shift :float = 9.0
var dial_lines :PackedVector2Array =[]
var line_thick :float = 2
var clock_R :float

var hands_line :Dictionary # p1,p2,width

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

func make_hands()->void:
	var ms = Time.get_unix_time_from_system()
	var second = ms - int(ms/60)*60
	ms = ms / 60
	var minute = ms - int(ms/60)*60
	ms = ms / 60
	var hour = ms - int(ms/24)*24 + tz_shift
	var rad_second = -second2rad(second)+PI
	var rad_minute = -minute2rad(minute)+PI
	var rad_hour = -hour2rad(hour)+PI
	hands_line.hour1 = [make_pos_by_rad_r(rad_hour,clock_R*0.7),make_pos_by_rad_r(rad_hour,clock_R* -0.1), line_thick*5 ]
	hands_line.hour2 = [make_pos_by_rad_r(rad_hour,clock_R*0.6),make_pos_by_rad_r(rad_hour,clock_R* -0.05), line_thick*2 ]
	hands_line.minute = [make_pos_by_rad_r(rad_minute,clock_R*0.8),make_pos_by_rad_r(rad_minute,clock_R* -0.2), line_thick*3 ]
	hands_line.second = [make_pos_by_rad_r(rad_second,clock_R*1.0),make_pos_by_rad_r(rad_second,clock_R* -0.3), line_thick*2 ]

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)

func init(r:float)->void:
	clock_R = r
	make_dial_lines(clock_R)
	line_thick = clock_R/200
	make_hands()

func _process(delta: float) -> void:
	make_hands()
	queue_redraw()

func _draw() -> void:
	draw_multiline(dial_lines,Global2d.colors.dial_1[0], line_thick)
	for k in ["hour1","hour2","minute","second"]:
		var v = hands_line[k]
		draw_line(v[0],v[1], Global2d.colors[k][0] ,v[2])
	draw_circle( Vector2(0,0), clock_R/25, Global2d.colors.center_circle1)
	draw_circle( Vector2(0,0), clock_R/30, Global2d.colors.center_circle2)

func second2rad(sec :float) -> float:
	return 2.0*PI/60.0*sec

func minute2rad(m :float) -> float:
	return 2.0*PI/60.0*m

func hour2rad(hour :float) -> float:
	return 2.0*PI/12.0*hour
