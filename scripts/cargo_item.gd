extends MarginContainer

var _deliver_button : Button = null

func _ready():
	_deliver_button = $horizontal/deliver_button

func _set_info(name, destination, weight):
	$horizontal/vertical/package_name.text = name
	$horizontal/vertical/package_destination.text = destination
	$horizontal/vertical/package_weight.text = String(weight)
	
func _deliver_package():
	var _idx = get_index()
	_globals._plane._cash += _globals._plane._packages[_idx]._price
	_globals._plane._packages.remove(_idx)
	queue_free()
