extends MarginContainer

onready var _plane_item = preload("res://prefabs/plane_item.tscn")
onready var _plane_instance = preload("res://prefabs/plane.tscn")

var _avail_index = 0

# elements needed for display of the current available plane
var _name : Label = null
var _location : Label = null
var _sprite : TextureRect = null
var _speed : Label = null
var _weight : Label = null
var _count : Label = null
var _purchase : Button = null

var _aircraft_names = [
	'Boeing 777F',
	'MD-11F',
	'MD-10-30F',
	'MD-10-10F',
	'Airbus A300-600F',
	'Airbus A310-200F'
]

export(int) var _max_available = 5

func _ready():
	_name = get_node("modal/margin/border/vertical/plane_list/content/horizontal/info/margin/horizontal/vertical/name")
	_location = get_node("modal/margin/border/vertical/plane_list/content/horizontal/info/margin/horizontal/vertical/location_name")
	_sprite = get_node("modal/margin/border/vertical/plane_list/content/horizontal/info/margin/horizontal/vertical/sprite")
	_speed = get_node("modal/margin/border/vertical/plane_list/content/horizontal/info/margin/horizontal/vertical/speed/speed")
	_weight = get_node("modal/margin/border/vertical/plane_list/content/horizontal/info/margin/horizontal/vertical/weight/weight")
	_count = get_node("modal/margin/border/vertical/plane_list/content/horizontal/info/avail_count")
	_purchase = get_node("modal/margin/border/vertical/actions/purchase_button")
	
	var _inst = _globals._aircraft[0].instance()
	_inst._location = randi() % _globals._locations.size()
	_globals._available.append(_inst)
	_update_inventory(0)

func _generate_available_plane():
	randomize()
	var _plane = _globals._plane_instance.instance()
	_globals._available.append(_plane)

func _update_inventory(override : int = 0):
	if _globals._available.size() > 0:
		var _idx = override if override != null else _avail_index
		var _aircraft = _globals._available[_idx]
		$modal/margin/border/vertical/plane_list/content/horizontal.visible = true
		$modal/margin/border/vertical/plane_list/content/none_available.visible = false
		if _avail_index != null:
			if _count != null:
				if _globals._available.size() > 0:
					_count.text = String(_idx + 1) + " / " + String(_globals._available.size())
				else:
					_count.text = ""
					
			if _name != null:
				_name.text = _aircraft._title
				
			if _location != null:
				_location.text = _globals._locations[_aircraft._location]._location_name
				
			if _sprite != null:
				_sprite.texture = _aircraft._get_sprite_texture()
				
			if _purchase != null:
				_purchase.disabled = _globals._cash <= _aircraft._value
	else:
		$modal/margin/border/vertical/plane_list/content/horizontal.visible = false
		$modal/margin/border/vertical/plane_list/content/none_available.visible = true

func _purchase_aircraft():
	var _aircraft = _globals._available[_avail_index]
	var _sliced = _globals._available.slice(_avail_index, _avail_index)[0]
	_globals._available.remove(_avail_index)
	_globals._fleet.append(_sliced)
	get_tree().root.add_child(_sliced)
	
	var _version = 0
	for _craft in _globals._fleet:
		if _craft._title == _aircraft._title:
			_version += 1
	
	_globals._fleet_idx = 0
	_globals._save()
	_update_inventory(0)
	_ui._dashboard._update_global_info(-(_aircraft._value))
	_ui._dashboard._hide_all_aircraft()
	_ui._dashboard._show_current_aircraft()
	_ui._dashboard._determine_switcher_content()
	_ui._dashboard._set_aircraft_info()
	
	if _globals._tutorial:
		_ui._tutorial_2.visible = false
		_ui._close_modals()
		_ui._dashboard._shop.disabled = true
		_ui._cargo_tutorial.visible = true

func _generate_available_aircraft():
	pass
	
func _next_avail():
	if _avail_index + 1 >= _globals._available.size():
		_avail_index = 0
	else:
		_avail_index += 1
		
	_update_inventory(_avail_index)

func _prev_avail():
	if _avail_index - 1 < 0:
		_avail_index = (_globals._available.size() - 1)
	else:
		_avail_index -= 1
		
	_update_inventory(_avail_index)

func _determine_ui_elements():
	$modal/margin/border/vertical/horizontal/close.disabled = _globals._tutorial
	$modal/margin/border/vertical/plane_list/content/horizontal/prev_avail.disabled = _globals._tutorial
	$modal/margin/border/vertical/plane_list/content/horizontal/next_avail.disabled = _globals._tutorial
	$modal/margin/border/vertical/actions/purchase_button.disabled = _globals._available.size() == 0
