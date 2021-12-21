extends Node2D

var _cargo_inst = preload("res://prefabs/cargo.tscn")
var _persist = {
	"warehouse": []
}

export(String) var _location_name = 'Location Name'
export(int) var _warehouse_size = 5

signal _location_select

onready var _stop_button = get_node("click_area")
onready var _texture_button = get_node("click_area/add_stop")

var _add_sprite = preload("res://assets/sprites/add_loc_sprite.png")
var _remove_sprite = preload("res://assets/sprites/remove_loc_sprite.png")

var _cargo = preload("res://prefabs/cargo.tscn")
var _cargo_item = preload("res://prefabs/cargo_item.tscn")
var _warehouse : Array = []

func _ready():
	$label.text = _location_name
	
func _generate_cargo():
	if _warehouse.size() < _warehouse_size:
		#create a new random package
		var _inst = _cargo.instance()
		_inst._randomize(_globals._find_location_index(_location_name))
		_warehouse.append(_inst)

func _get_planes_landed():
	var _amount = 0
	for _plane in _globals._fleet:
		if _globals._locations[_plane._location] == self:
			_amount += 1

func _update_inventory(_aircraft = false):
	_clear_inventory()
	for _item in _warehouse if !_aircraft else _globals._plane._cargo:
		var _inst = _cargo_item.instance()
		_inst._set_info(_item._description, _item._dest, _item._weight, _item, !_aircraft)
		_inst.connect("_on_load_cargo", self, "_load_cargo")
		_inst.connect("_on_remove_cargo", self, "_remove_cargo")
		_ui._cargo_list.add_child(_inst)

func _clear_inventory():
	for _child in _ui._cargo_list.get_children():
		_child.queue_free()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if _texture_button.get_global_rect().has_point(get_global_mouse_position()) and _globals._plane._location != _globals._locations.find(self):
				if _globals._plane._stops.find(self) == -1:
					_globals._plane._stops.append(self)
					_texture_button.texture_normal = _remove_sprite
				else:
					_texture_button.texture_normal = _add_sprite
					_globals._plane._stops.remove(_globals._plane._stops.find(self))
					
				emit_signal("_location_select")

func _load_cargo(cargo):
	var _idx = _warehouse.find(cargo)
	var _package = _warehouse[_idx]
	_globals._plane._cargo.append(_package)
	_warehouse.remove(_idx)
	
	_update_inventory()
	_ui._warehouse._update_info()

func _remove_cargo(cargo):
	print("working")

func _save():
	for _item in _warehouse:
		_persist["warehouse"].append(_item._save())

	return _persist

func _load(data):
	for _item in data.warehouse:
		var _inst = _cargo_inst.instance()
		_inst._load(_item)
		_warehouse.append(_inst)
