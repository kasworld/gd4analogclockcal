extends Node2D

var enabled = false
var state = 0
var begin_tick = 0
var period = 1.0
var remain_step :int

func toggle()->void:
	if enabled:
		stop()
	else:
		start(period)

func start(p :float = 1)->void:
	period = p
	enabled = true
	begin_tick = Time.get_unix_time_from_system()
	$Timer.start(period)

# auto stop after step state change
func start_with_step(step :int, p :float = 1, )->void:
	remain_step = step
	start(p)

func stop()->void:
	enabled = false
	$Timer.stop()

# v1,v2 : + - , * with float
func calc_inter(v1 , v2 , t :float)->Vector2:
	return (cos(t *PI / period)/2 +0.5) * (v1-v2) + v2

# o :position , p1,p2 : + - , * with float
func move_by_ms(o , p1 , p2 , ms:float)->void:
	o.position = calc_inter(p1,p2,ms)

# o :position, pos_list[n] : + - , * with float
func move_node2d(o , pos_list :Array, ms :float)->void:
	var l = pos_list.size()
	var p1 = pos_list[state%l]
	var p2 = pos_list[(state+1)%l]
	o.position = calc_inter(p1,p2,ms)

func get_ms()->float:
	return Time.get_unix_time_from_system() - begin_tick

func _on_timer_timeout() -> void:
	state += 1
	begin_tick = Time.get_unix_time_from_system()
	if remain_step > 0 :
		remain_step -= 1
		stop()
