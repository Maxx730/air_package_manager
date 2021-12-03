extends Node2D

export(String) var _location_name = 'Location Name'

signal _location_select

onready var _stop_button = get_node("click_area")

var _add_sprite = preload("res://assets/sprites/add_loc_sprite.png")
var _remove_sprite = preload("res://assets/sprites/remove_loc_sprite.png")
var _package_instance = preload('res://prefabs/package.tscn')
var _packages : Array = []

func _ready():
	$label.text = _location_name
	

func _landing_zone_entered(area):
	if area.get_parent().name == 'plane' and area.get_parent()._destination == self:
		_globals._current_location = self
		_globals._plane._moving = false
		# open cargo to deliver
		if _globals._plane._packages.size() > 0:
			_globals._plane._open_cargo()
		else:
			_globals._plane._open_location()

func _generate_package():
	randomize()
	var _package = _package_instance.instance()

	while _package._destination == self:
		randomize()
		_package._destination = _globals._locations[rand_range(0, _globals._locations.size())]
	
	_package._price = stepify(position.distance_to(_package._destination.position) / _package._weight, 0.01)
	_packages.append(_package)

func _left_landing_zone(area):
	pass

func _get_planes_landed():
	var _amount = 0
	for _plane in _globals._fleet:
		if _globals._locations[_plane._location] == self:
			_amount += 1
			
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var _col : CollisionShape2D = $click_area/collider
			if $click_area/add_stop.get_global_rect().has_point(get_global_mouse_position()):
				if _globals._path.find(self) == -1:
					_globals._path.append(self)
					$click_area/add_stop.texture_normal = _remove_sprite
				else:
					$click_area/add_stop.texture_normal = _add_sprite
					_globals._path.remove(_globals._path.find(self))
					
				emit_signal("_location_select")

