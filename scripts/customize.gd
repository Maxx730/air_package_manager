extends MarginContainer

onready var _input = $shadow/outline/content/vert/value

func _ready():
	pass

func _fill_customize_data():
	var _aircraft = _globals._get_aircraft()
	_input.text = _aircraft._title

func _apply_customizations():
	var _aircraft = _globals._get_aircraft()
	_aircraft._title = _input.text
	
	_ui._shade.visible = false
	_ui._customize.visible = false
	
	_ui._dashboard._set_aircraft_info()
	_globals._save()
	_data._save_game()
