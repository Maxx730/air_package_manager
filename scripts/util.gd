extends Node

func _format_seconds(value, two_digit : bool = false):
	var _val = int(value)
	var _minutes = _val / 60
	var _seconds = _val % 60

	return String(0 if (_minutes < 10 and two_digit) else "") + String(_minutes) + ":" + String(0 if _seconds < 10 else "") + String(_seconds)

func _time_passed(start, end):
	return end - start
