extends MarginContainer

onready var _destinations = get_node("vertical/top/destinations")
onready var _switcher = $vertical/border/container/switcher
onready var _cash_indicator = get_node("shade/top/Panel/cash/cash_amount")
onready var _aircraft_count = get_node("vertical/shadow/border/container/content/aircraft_count")
onready var _aircraft_name = get_node("vertical/shadow/border/container/content/vertical/aircraft_name")
onready var _aircraft_location = get_node("vertical/shadow/border/container/content/vertical/aircraft_location")
onready var _cancel = get_node("cancel")


var _fleet_idx = 0

func _open_shop():
	_ui._close_modals()
	_ui._open_modal(_ui._shop)
	
func _open_location():
	_ui._close_modals()
	_ui._open_modal(_ui._location)

func _show_switcher():
	_switcher.visible = (_globals._fleet.size() > 0)

func _previous_aircraft():
	if _fleet_idx <= 0:
		_fleet_idx = (_globals._fleet.size() - 1)
	else:
		_fleet_idx -= 1
		
	_hide_all_aircraft()
	_show_current_aircraft()
	_set_aircraft_info()
	
func _next_aircraft():
	if _fleet_idx >= (_globals._fleet.size() - 1):
		_fleet_idx = 0
	else:
		_fleet_idx += 1
	
	_globals._plane = _globals._fleet[_fleet_idx]
	_hide_all_aircraft()
	_show_current_aircraft()
	_set_aircraft_info()
		
func _hide_all_aircraft():
	for _aircraft in _globals._fleet:
		_aircraft.visible = false

func _show_current_aircraft():
	_globals._fleet[_fleet_idx].visible = true

func _set_switcher_info(name, state):
	$vertical/current/name.text = name
	$vertical/current/location.text = state

func _update_cash_amount(val):
	if _cash_indicator != null:
		_cash_indicator.text = String(floor(val))
		_globals._cash = val

func _update_global_info(cash):
	$shade/top_value_tween.interpolate_method(self, "_update_cash_amount", _globals._cash, _globals._cash + cash, 3, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	$shade/top_value_tween.start()

func _set_aircraft_info():
	if _aircraft_count != null:
		_aircraft_count.text = String(_fleet_idx + 1) + " / " + String(_globals._fleet.size())
	
	if _aircraft_name != null:
		_aircraft_name.text = _globals._fleet[_fleet_idx]._title
		
	if _aircraft_location != null:
		_aircraft_location.text = _globals._locations[_globals._fleet[_fleet_idx]._location]._location_name

func _open_locations():
	_globals._map._hide_screens()
	var _locat = _globals._locations[_globals._fleet[_fleet_idx]._location]
	_ui._switcher.visible = false
	_ui._cancel.visible = true
	_globals._map._show_screen(1)
	_globals._main_camera._target = _locat
	for loc in _globals._locations:
		loc._stop_button.visible = true
	_locat._stop_button.visible = false
	for _aircraft in _globals._fleet:
		_aircraft.visible = false
