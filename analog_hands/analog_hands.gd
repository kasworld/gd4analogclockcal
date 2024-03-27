extends Node2D

class_name AnalogHands

var clock_R :float
var tz_shift :float

var hands_param = {
	# from, to , width : ratio of clock_R
	hour1 = [-0.2,0.7,0.04],
	hour2 = [-0.1,0.65,0.01],
	minute = [-0.3,0.9,0.02],
	second = [-0.4,1.0,0.01],
}
var show_center :bool
func init(r:float, tz_s :float, hp :Dictionary = hands_param, shct :bool = true)->void:
	hands_param = hp
	show_center = shct
	clock_R = r
	tz_shift = tz_s
	queue_redraw()

func update_color()->void:
	queue_redraw()

func _process(delta: float) -> void:
	queue_redraw()

var old_time_dict = {"second":0} # datetime dict
func _draw() -> void:
	var ms = Time.get_unix_time_from_system()
	var second = ms - int(ms/60)*60
	ms = ms / 60
	var minute = ms - int(ms/60)*60
	ms = ms / 60
	var hour = ms - int(ms/24)*24 + tz_shift
	var hands_rot = {
		second = -second2rad(second),
		minute = -minute2rad(minute),
		hour1 = -hour2rad(hour),
		hour2 = -hour2rad(hour),
	}
	for k in hands_param:
		var w = hands_param[k][2]
		var from = hands_param[k][0]
		var to = hands_param[k][1]
		var rad = hands_rot[k] +PI
		var p1 = make_pos_by_rad_r(rad, from*clock_R)
		var p2 = make_pos_by_rad_r(rad, to*clock_R)
		draw_line(p1,p2,Global2d.colors[k] ,w*clock_R  )

	if show_center:
		draw_circle(Vector2(0,0), clock_R/25, Global2d.colors.center_circle1)
		draw_circle(Vector2(0,0), clock_R/30, Global2d.colors.center_circle2)

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)

func second2rad(sec :float) -> float:
	return 2.0*PI/60.0*sec

func minute2rad(m :float) -> float:
	return 2.0*PI/60.0*m

func hour2rad(hour :float) -> float:
	return 2.0*PI/12.0*hour
