extends MarginContainer

onready var _location_title = $vert/location_title

func _next_location():
	var _idx = _globals._locations.find(_globals._main_camera._target)
	if _idx + 1 < _globals._locations.size():
		_globals._main_camera._target = _globals._locations[_idx + 1]
		_update_switcher_info(_idx + 1)
	else:
		_globals._main_camera._target = _globals._locations[0]
		_update_switcher_info(0)

func _previous_location():
	var _idx = _globals._locations.find(_globals._main_camera._target)
	if _idx - 1 >= 0:
		_globals._main_camera._target = _globals._locations[_idx - 1]
		_update_switcher_info(_idx - 1)
	else:
		_globals._main_camera._target = _globals._locations[_globals._locations.size() - 1]
		_update_switcher_info(_globals._locations.size() - 1)

func _update_switcher_info(_idx):
	_globals._main_camera._panning = false
	_location_title.text = _globals._locations[_idx]._location_name
