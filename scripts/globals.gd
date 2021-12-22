extends Node

enum SCREENS {
	SHOP,
	MAP,
	RUNWAY,
	SKY,
	CARGO
}

enum PLANE_STATE {
	LANDED,
	DEPARTING,
	IN_TRANSIT,
}

var _available : Array = []
var _fleet : Array = []
var _fleet_idx : int = -1
var _plane : Node2D = null
var _tutorial : bool = false
var _cash = 2125
var _locations : Array = []
var _current_location : Node2D = null
var _main_camera : Camera2D = null
var _world : Node2D = null
var _map : Node2D = null
var _path : Array = []
var _switcher : HBoxContainer = null
var _passed = -1

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
	"fleet_idx": -1,
	"warehouses": [],
	"cash": _cash
}

func _ready():
	_add_locations()

func _load_world():
	var data = _data._load_game()

	if data != null and !_tutorial:
		# since there is already save data, they SHOULD have gone
		# through the tutorial 
		_ui._title.visible = false
		_map._hide_screens()
		
		if data.lastOpened != null:
			_passed = _util._time_passed(data.lastOpened, OS.get_unix_time())
		
		# load the fleet if the player has already 
		if data.fleet.size() > 0:
			_spawn_fleet(data)
			
			# if the fleet index is greater than -1 then it has been
			# set before and we should use it, otherwise just default to zero
			_fleet_idx = data.fleet_idx if data.fleet_idx > -1 else 0
			# show the sprite for the current aircraft and update the information
			_ui._dashboard._hide_all_aircraft()
			_ui._dashboard._show_current_aircraft()
			_ui._dashboard._set_aircraft_info()
		
		_map._determine_aircraft_scene(_fleet[_fleet_idx]._state if _fleet_idx > -1 else 0)
		_ui._determine_ui_actions(_fleet[_fleet_idx]._state if _fleet_idx > -1 else -1)
		
		#load available aircraft if they exist
		if data.available.size() > 0:
			#load previously available aircraft into the shop
			_generate_available(data)
			_ui._shop._update_inventory()
			
			
			#_globals._cash = data.cash

			#_tutorial = false
		
		#load location's warehouse cargo
		_load_locations(data)
	else:
		_ui._title.visible = true
	
	_ui._dashboard._update_cash_amount(_cash)
	_map._set_lighting()

# listens for Godot notifications to save a load from filesystem
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		_data._load_game()
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		_data._save_game()

func _save():
	_persist["lastOpened"] = OS.get_unix_time()
	_persist["cash"] = _cash
	_persist["fleet_idx"] = _fleet_idx
	#empty arrays before saving them all to prevent duplicates
	_persist["fleet"] = []
	_persist["available"] = []
	_persist["warehouses"] = []
	
	#Save arrays of entities here
	for _plane in _fleet:
		_persist["fleet"].append(_plane._save())
	for _plane in _available:
		_persist["available"].append(_plane._save())
	for _location in _locations:
		_persist["warehouses"].append(_location._save())
		
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

func _find_location_index(name : String):
	var _idx = -1
	for _location in _locations:
		if _location._location_name == name:
			_idx = _locations.find(_location)
	return _idx

func _load_locations(data):
	for _location in _locations:
		var _idx = _locations.find(_location)
		_location._load(data.warehouses[_idx])

func _get_aircraft():
	return _fleet[_fleet_idx]
