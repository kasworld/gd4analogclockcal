extends Node2D

class_name AnalogHands

var clock_R :float
var tz_shift :float

# use for calc hand angle
enum HandType {Hour, Minute, Second}

# default
var hands_param = [
	# hands type, color key, from, to , width : ratio of clock_R
	[HandType.Hour, "hour1", -0.2,0.7,0.04],
	[HandType.Hour, "hour2", -0.1,0.65,0.01],
	[HandType.Minute, "minute", -0.3,0.9,0.02],
	[HandType.Second, "second", -0.4,1.0,0.01],
]
var show_center :bool

func init(r:float, tz_s :float, hp :Array = hands_param, shct :bool = true)->void:
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
	for v in hands_param:
		var rad = -calc_rad_for_hand(ms, v[0]) +PI
		var co = Global2d.colors[v[1]]
		var p1 = make_pos_by_rad_r(rad, v[2]*clock_R)
		var p2 = make_pos_by_rad_r(rad, v[3]*clock_R)
		draw_line(p1, p2, co, v[4]*clock_R  )

	if show_center:
		draw_circle(Vector2(0,0), clock_R/25, Global2d.colors.center_circle1)
		draw_circle(Vector2(0,0), clock_R/30, Global2d.colors.center_circle2)

func make_pos_by_rad_r(rad:float, r :float)->Vector2:
	return Vector2(sin(rad)*r, cos(rad)*r)

func calc_rad_for_hand(ms :float, hd :HandType)->float:
	var second = ms - int(ms/60)*60
	ms = ms / 60
	var minute = ms - int(ms/60)*60
	ms = ms / 60
	var hour = ms - int(ms/24)*24 + tz_shift
	match hd:
		HandType.Hour:
			return hour2rad(hour)
		HandType.Minute:
			return minute2rad(minute)
		HandType.Second:
			return second2rad(second)
	return 0

func second2rad(sec :float) -> float:
	return 2.0*PI/60.0*sec

func minute2rad(m :float) -> float:
	return 2.0*PI/60.0*m

func hour2rad(hour :float) -> float:
	return 2.0*PI/12.0*hour
