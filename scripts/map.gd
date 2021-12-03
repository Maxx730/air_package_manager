extends Node2D

export(Gradient) var _daytime_color : Gradient

func _enter_tree():
	_globals._map = self

func _set_lighting():
	var _hour : float = OS.get_time()["hour"]
	var _value : float = floor((_hour / 24) * _daytime_color.get_point_count())
	_value = 1
	$shade.color = _daytime_color.get_color(_value)
	_globals._set_aircraft_lights(_value < 1 or _value >= (_daytime_color.get_point_count() - 1))
