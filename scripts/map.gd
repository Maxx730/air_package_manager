extends Node2D

export(Gradient) var _daytime_color : Gradient

onready var _screens = [
	get_node("runway"),
	get_node("locations"),
	get_node("transit"),
	get_node("title")
]

func _enter_tree():
	_globals._map = self

func _set_lighting():
	pass

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
