extends MarginContainer

var _location : Node2D = null
var _package : Node2D = null

func _set_information(name, destination, weight, location, package):
	$horizontal/VBoxContainer/package_name.text = name
	$horizontal/VBoxContainer/package_weight.text = String(weight)
	$horizontal/VBoxContainer/package_destination.text = _globals._locations[destination]._location_name
	
	_location = location
	_package = package

func _add_package():
	var _idx = get_index()
	var _removed = _globals._current_location._packages.slice(_idx, _idx)[0]
	
	_globals._current_location._packages.remove(_idx)
	_globals._plane._packages.append(_removed)
	_globals._plane._update_cargo()
	queue_free()
