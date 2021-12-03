extends Node2D

export(String) var _location_name = 'Location Name'

var _package_instance = preload('res://prefabs/package.tscn')
var _packages : Array = []

func _ready():
	$info/title.text = _location_name

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
			
	$info/horizontal/plane_count/count.text = String(_amount)
