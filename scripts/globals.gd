extends Node

var _available : Array = []
var _fleet : Array = []
var _plane : Node2D = null

var _cash = 2125
var _locations : Array = []
var _current_location : Node2D = null
var _main_camera : Camera2D = null
var _world : Node2D = null
var _map : Node2D = null

#scenes
var _plane_instance = preload("res://prefabs/plane.tscn")
var _aircraft = [
	preload("res://prefabs/aircraft/airbus_generic.tscn"),
	preload("res://prefabs/aircraft/cesna_generic.tscn"),
	preload("res://prefabs/aircraft/310_generic.tscn"),
	preload("res://prefabs/aircraft/skymaster_generic.tscn"),
	preload("res://prefabs/aircraft/challenger_generic.tscn"),
	preload("res://prefabs/aircraft/airmuel_generic.tscn")
]

var _persist : Dictionary = {
	"lastOpened": {},
	"available": [],
	"fleet": [],
	"cash": _cash
}

func _ready():
	_add_locations()

func _load_world():
	var data = _data._load_game()

	if data != null:
		if data.fleet.size() > 0:
			_spawn_fleet(data)
			
		if data.available.size() > 0:
			_generate_available(data)
			_globals._cash = data.cash
			_ui._dashboard._update_global_info(0)
			_ui._shop._update_inventory(0)
			_update_locations()
			
			_ui._dashboard._hide_all_aircraft()
			_ui._dashboard._show_current_aircraft()
			_ui._dashboard._set_aircraft_info()
	else:
		_ui._dashboard._switcher.visible = false
		
	_map._set_lighting()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		get_tree().paused = false
		_data._load_game()
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		get_tree().paused = true
		_data._save_game()

func _save():
	_persist["lastOpened"] = OS.get_time()
	_persist["cash"] = _cash
	for _plane in _fleet:
		_persist["fleet"].append(_plane._save())
	for _plane in _available:
		_persist["available"].append(_plane._save())
	return _persist
	
func _add_locations():
	_locations = get_tree().get_nodes_in_group('location')

func _fill_shop():
	for i in range(5):
		randomize()
		var _plane = _plane_instance.instance()
		_plane._location = randi() % _locations.size()
		_available.append(_plane)

func _generate_available(data):
	for _item in data.available:
		var _instance = load(_item.file).instance()
		_instance._load(_item)
		_available.append(_instance)
	
func _spawn_fleet(data):
	for _item in data.fleet:
		var _instance = load(_item.file).instance()
		_instance._load(_item)
		_fleet.append(_instance)
		_world.add_child(_instance)
		_plane = _instance
	
	if _plane != null:
		_ui._dashboard._set_switcher_info(_plane._title, _plane._get_state())

func _update_locations():
	for _location in _locations:
		_location._get_planes_landed()

func _set_aircraft_lights(val):
	for _aircraft in _fleet:
		_aircraft._set_lights(val)
		
	for _aircraft in _available:
		_aircraft._set_lights(val)
