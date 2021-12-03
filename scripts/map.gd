extends Node2D

export(Gradient) var _daytime_color : Gradient

onready var _screens = [
	get_node("runway"),
	get_node("locations")
]

func _enter_tree():
	_globals._map = self

func _set_lighting():
	var _hour : float = OS.get_time()["hour"]
	var _value : float = floor((_hour / 24) * _daytime_color.get_point_count())
	_value = 1
	$shade.color = _daytime_color.get_color(_value)
	_globals._set_aircraft_lights(_value < 1 or _value >= (_daytime_color.get_point_count() - 1))

func _hide_screens():
	for _screen in _screens:
		_screen.visible = false
		
func _show_screen(idx):
	if _screens.size() > idx:
		_screens[idx].visible = true

func _cancel_action_pressed():
	_hide_screens()
	_show_screen(0)
	_globals._path.clear()
	$locations/trip_line.clear_points()
	_globals._plane.visible = true
	_ui._switcher.visible = true
	_ui._cancel.visible = false
	_globals._main_camera._target = null
	_globals._main_camera._panning = false
	_globals._main_camera.position = Vector2.ZERO
