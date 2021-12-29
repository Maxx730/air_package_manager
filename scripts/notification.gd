extends MarginContainer

export(bool) var _remove = true
export(float, 1, 6) var _length = 1.0

func _set_info(message : String, length : float = 1.0):
	$timeout.wait_time = length
	$shade/border/content/vert/hor/message.text = message

func _destroy_notification():
	if _remove:
		queue_free()

func _fade_out():
	if _remove:
		$fade.interpolate_property(self, 'modulate', modulate, Color(0, 0, 0, 0), 1, Tween.EASE_IN_OUT, Tween.EASE_IN_OUT)
		$fade.start()
