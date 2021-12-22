extends Node2D

enum PLANE_CLASS {
	CLASS_ONE,
	CLASS_TWO,
	CLASS_THREE
}

var _sprites = [
	preload("res://assets/sprites/aircraft/cesna_generic.png"),
	preload("res://assets/sprites/aircraft/airbus_generic.png"),
	preload("res://assets/sprites/aircraft/310_generic.png"),
	preload("res://assets/sprites/aircraft/skymaster_generic.png")
]

var _persist = {
	"title": "Aircraft Name",
	"file": filename,
	"state": _globals.PLANE_STATE.LANDED,
	"cargo": [],
	"location": -1,
	"sprite": null,
	"stops": [],
	"arrival": 0,
	"position": {
		"x": 0,
		"y": 0
	},
	"departure_time": null
}

var _cargo_inst = preload("res://prefabs/cargo.tscn")

#EXPORTED VALUES
export(String) var _title : String = 'Boeing 777F'
export(float) var _max_speed : float = 100.0
export(float) var _capacity : float = 50.0
export(float) var _tank : float = 50000.0
export(float) var _efficiency : float = 12.0

#CONSTANTS
var _class : int = PLANE_CLASS.CLASS_ONE
var _state : int = _globals.PLANE_STATE.LANDED
var _fuel : float = _tank

#DELIVERY DATA
var _length = 0 #How long will the distance to the next stop be in seconds
var _cargo : Array = []
var _stops = []
var _location : int = -1

var _value = 100.0
var _departure_time = null

func _ready():
	position.y -= 65

func _process(delta):
	if _state == _globals.PLANE_STATE.IN_TRANSIT:
		pass

func _tick():
	if _length <= 1:
		if _state == _globals.PLANE_STATE.IN_TRANSIT:
			_state = _globals.PLANE_STATE.LANDED
			#since the plane has arrived at its destination, we need to 
			#change it's state and update the scene based on the state
			#(only if we are watching the aircraft that is in transit)
			if _globals._fleet.find(self) == _globals._fleet_idx:
				_ui._dashboard._hide_all_aircraft()
				_ui._dashboard._show_current_aircraft()
				_ui._dashboard._set_aircraft_info()
				_globals._map._determine_aircraft_scene(_state)
				_ui._determine_ui_actions(_state)
	else:
		_length -= 1
		_fuel -= _efficiency
		if _globals._fleet.find(self) == _globals._fleet_idx:
			_update_transit_ui()

func _transit_animations(delta):
	_sway()

func _save():
	_persist["title"] = _title
	_persist["state"] = _state
	_persist["location"] = _location
	_persist["file"] = filename
	_persist["sprite"] = $sprite.texture.resource_path
	_persist["arrival"] = _length
	#empty out arrays to prevent duplicates
	_persist["stops"] = []
	_persist["cargo"] = []
	
	for _stop in _stops:
		_persist["stops"].append(_globals._locations.find(_stop))
	
	for _item in _cargo:
		_persist["cargo"].append(_item._save())
	
	_persist["position"] = {
		"x": position.x,
		"y": position.y
	}
	return _persist

func _load(data):
	_title = data.title
	_location = data.location
	_state = data.state
	_length = clamp(data.arrival - _globals._passed if (_globals._passed > 0 and _state == _globals.PLANE_STATE.IN_TRANSIT) else 0, 0, data.arrival)

	if _length == 0 and _state == _globals.PLANE_STATE.IN_TRANSIT:
		_state = _globals.PLANE_STATE.LANDED

	$sprite.texture = load(data.sprite)
	
	# load the cargo into memory
	for _item in data.cargo:
		var _inst = _cargo_inst.instance()
		_inst._load(_item)
		_cargo.append(_inst)
	
	for _stop in data.stops:
		_stops.append(_globals._locations[_stop])

func _get_state():
	match _state:
		0:
			return 'Landed'
		1:
			return 'In Transit'
		2:
			return 'Fueling'

func _sway():
	$sway.interpolate_property($sprite, 'position', $sprite.position, Vector2(3, $sprite.position.y), 6, Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	$sway.start()
	
func _sway_complete():
	randomize()
	$sway.interpolate_property($sprite, 'position', $sprite.position, Vector2((randi() % 6) * -1, $sprite.position.y), 6, Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	$sway.start()

func _set_lights(val):
	$sprite/lights.visible = val

func _get_sprite_texture():
	return $sprite.texture

func _get_weight():
	var _weight = 0
	for _item in _cargo:
		_weight += _item._weight
		
	return _weight

func _update_transit_ui():
	if _state == _globals.PLANE_STATE.IN_TRANSIT:
		_ui._trip_time.text = _util._format_seconds(_length)
		_ui._to_name.text = _globals._plane._stops[0]._location_name
		_ui._from_name.text = _globals._locations[_globals._plane._location]._location_name
		_ui._dashboard._fuel_indicator.text = String(floor((_fuel / _tank) * 100.0)) + "%"
