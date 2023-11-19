extends Node2D

func init(rt :Rect2)->void:
	var co :Color
	co = Global.colors.timelabel
	$TimeLabel.init(
		Rect2(-rt.size.x/2/1.5, -rt.size.y/3, rt.size.x/1.5, rt.size.y/3),
		co, Global.make_shadow_color(co))
	$TimeLabel.position = Vector2(0,0)

	$AnalogClock.init( Vector2(0, 0), rt.size.y/2 , 9.0 )
	$AnalogClock.position = Vector2(0,0)

	co = Global.colors.infolabel
	$InfoLabel.init(
		Rect2(-rt.size.x/2/1.5, rt.size.y/20, rt.size.x/1.5, rt.size.y/3),
		co, Global.make_shadow_color(co) )
	$InfoLabel.position = Vector2(0,0)

func update_color()->void:
	$TimeLabel.update_color()
	$InfoLabel.update_color()
	$AnalogClock.update_color()

func get_req_callable()->Dictionary:
	return $InfoLabel.get_req_callable()
