extends Node2D

var _start_pos = null

func _ready():
	_start_pos = $aircraft.position
	_move_plane()

func _move_plane():
	$tween.interpolate_property($aircraft, 'position', _start_pos, Vector2(_start_pos.x, _start_pos.y - 1400), 15, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	$tween.start()
	
func _on_between():
	_move_plane()
	
func _start_game():
	_globals._map._hide_screens()
	_globals._map._show_screen(0)
	_ui._title.visible = false
	_ui._dashboard.visible = true
	_ui._switcher.visible = true
	_ui._dashboard._determine_switcher_content()
	if _globals._tutorial:
		_ui._tutorial_1.visible = true
