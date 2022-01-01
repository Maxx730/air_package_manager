extends Node2D

export(NodePath) var _lighting : NodePath
export(Color) var _night_color : Color
export(Color) var _early_morning_color : Color
export(Color) var _morning_color : Color
export(Color) var _daytime_color : Color
export(Color) var _dusk_color : Color

export(float, 0, 1) var _night_alpha = 0.75
export(float, 0, 1) var _day_alpha = 0.35

onready var _screens = [
	get_node("runway"),
	get_node("locations"),
	get_node("transit"),
	get_node("title")
]

func _enter_tree():
	_globals._map = self

func _set_lighting(var _force : int = -1):
	var _light = $lighting
	var _hour = OS.get_time().hour if _force < 0 else _force
	if _hour < 5 and _hour > -1:
		_light.color = _night_color
	elif _hour < 8 and _hour > 5:
		_light.color = _early_morning_color
	elif _hour < 10 and _hour > 8:
		_light.color = _morning_color
	elif _hour < 18 and _hour > 10:
		_light.color = _daytime_color
	elif _hour < 21 and _hour > 17:
		_light.color = _dusk_color
	elif _hour < 24 and  _hour > 20:
		_light.color = _night_color

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
	_ui._global_actions.visible = false
	_globals._main_camera._target = null
	_globals._main_camera._panning = false
	_globals._main_camera.position = Vector2.ZERO

func _determine_aircraft_scene(state : int = 0):
	_hide_screens()
	
	match state:
		_globals.PLANE_STATE.LANDED:
			_globals._main_camera._reset()
			_ui._dashboard._show_current_aircraft()
			_show_screen(0)
		_globals.PLANE_STATE.IN_TRANSIT:
			_globals._main_camera._reset()
			_ui._dashboard._show_current_aircraft()
			_show_screen(2)
		_globals.PLANE_STATE.DEPARTING:
			_globals._main_camera._reset()
			_show_screen(1)
			_globals._main_camera._target = _util._get_location(_globals._get_aircraft()._location)
