extends MarginContainer

var _warehouse = true;

onready var _change_button = $margin/vertical/to_cargo
onready var _location_name = $margin/vertical/horizontal/margin/location_name
onready var _weight_amount = $margin/vertical/content/vertical/weight_info/weight

func _determine_interface():
	$margin/vertical/horizontal/close_locaton.disabled = _globals._tutorial

func _switch_container():
	var _location = _globals._locations[_globals._plane._location]
	var _aircraft = _globals._plane._title
	
	if _warehouse:
		_change_button.text = "< " + _location._location_name + " Warehouse"
		_location._update_inventory(true)
	else:
		_change_button.text = _aircraft + " Cargo > "
		_location._update_inventory(false)
	
	_update_info()
	_warehouse = !_warehouse

func _update_info():
	_weight_amount.text = String(stepify(_globals._plane._get_weight(), 0.1)) + " / " + String(stepify(_globals._plane._capacity, 0.1))
	
