extends NinePatchRect

var _start_pos = null
var _down = true
var _time = 1

func _ready():
	_start_pos = get_parent().get_global_rect().size
	print(rect_global_position)
	print(get_viewport_transform() * get_global_transform())


func _move_bubble(val):
	if _down:
		$tween.interpolate_property(self, 'rect_position', _start_pos, Vector2(_start_pos.x, _start_pos.y + val), _time, Tween.EASE_IN_OUT, Tween.EASE_IN_OUT)
		$tween.start()
	else:
		$tween.interpolate_property(self, 'rect_position', _start_pos, Vector2(_start_pos.x, _start_pos.y - val), _time, Tween.EASE_IN_OUT, Tween.EASE_IN_OUT)
		$tween.start()
		
	_down = !_down


func _bounce_end():
	_move_bubble(-100 if _down else 100)
