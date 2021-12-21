extends HBoxContainer

signal _on_load_cargo
signal _on_remove_cargo

onready var _deliver_button : Button = $background/vert/action_button/action

var _carg_ref = null
var _in_warehouse = true

func _set_info(desc : String, loc : int, weight, ref, warehouse = true):
	$background/vert/values/VBoxContainer/description.text = desc.to_upper() + "(S)"
	$background/vert/values/VBoxContainer/location.text = _globals._locations[_ui._dashboard._fleet_idx]._location_name + " to " + _globals._locations[loc]._location_name
	$background/vert/values/VBoxContainer/weight.text = String(stepify(weight,0.1)) + "LB"
	if !warehouse:
		$background/vert/action_button.visible = false
		$background/vert/remove_button.visible = true
	else:
		$background/vert/action_button.visible = true
		$background/vert/remove_button.visible = false
	_in_warehouse = warehouse
	_carg_ref = ref

func _load_cargo():
	if _carg_ref != null and _in_warehouse:
		emit_signal("_on_load_cargo", _carg_ref)

func _remove_cargo():
	if _carg_ref != null and !_in_warehouse:
		emit_signal("_on_remove_cargo", _carg_ref)

func _deliver_package():
	pass
