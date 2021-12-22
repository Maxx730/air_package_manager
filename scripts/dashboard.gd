extends MarginContainer

onready var _destinations = get_node("vertical/top/destinations")
onready var _switcher = $vertical/border/container/switcher
onready var _cash_indicator = get_node("shade/top/Panel/cash/cash_amount")
onready var _aircraft_count = get_node("vertical/shadow/border/container/content/aircraft_count")
onready var _aircraft_name = get_node("vertical/shadow/border/container/content/vertical/name/aircraft_name")
onready var _aircraft_location = get_node("vertical/shadow/border/container/content/vertical/aircraft_location")
onready var _cancel = get_node("cancel")
onready var _no_aircraft = $vertical/shadow/border/container/empty_fleet
onready var _choose_aircraft = $vertical/shadow/border/container/content
onready var _next_craft = $vertical/shadow/border/container/switcher/next_aircraft
onready var _prev_craft = $vertical/shadow/border/container/switcher/prev_aircraft
onready var _depart = $vertical/shadow/border/container/switcher/horizontal/depart
onready var _shop = $vertical/shadow/border/container/switcher/horizontal/open_shop
onready var _location = $vertical/shadow/border/container/switcher/horizontal/open_location
onready var _fuel_indicator = $vertical/shadow/border/container/content/vertical/VBoxContainer/values/HBoxContainer/_fuel_indicator

var _fleet_idx = 0

func _open_shop():
	_ui._close_modals()
	_ui._open_modal(_ui._shop)
	
	_ui._shop._determine_ui_elements()
	if _globals._tutorial:
		_ui._tutorial_1.visible = false
		_ui._tutorial_2.visible = true
	
func _open_location():
	_ui._close_modals()
	_ui._open_modal(_ui._warehouse)
	var _loc = _globals._locations[_fleet_idx]
	_loc._update_inventory()
	_ui._warehouse._change_button.text = _globals._plane._title + " Cargo >"
	_ui._warehouse._location_name.text = _loc._location_name
	
	if _globals._tutorial:
		_ui._cargo_tutorial.visible = false

func _show_switcher():
	_switcher.visible = (_globals._fleet.size() > 0)

func _previous_aircraft():
	if _globals._fleet_idx <= 0:
		_globals._fleet_idx = (_globals._fleet.size() - 1)
	else:
		_globals._fleet_idx -= 1
		
	_hide_all_aircraft()
	_show_current_aircraft()
	_set_aircraft_info()

	var _aircraft = _globals._fleet[_globals._fleet_idx]
	_globals._map._determine_aircraft_scene(_aircraft._state)
	_ui._determine_ui_actions(_aircraft._state)
	_aircraft._update_transit_ui()
	
func _next_aircraft():
	if _globals._fleet_idx >= (_globals._fleet.size() - 1):
		_globals._fleet_idx = 0
	else:
		_globals._fleet_idx += 1
	
	# Reset the aircraft info and sprite
	_hide_all_aircraft()
	_show_current_aircraft()
	_set_aircraft_info()
	
	var _aircraft = _globals._fleet[_globals._fleet_idx]
	_globals._map._determine_aircraft_scene(_aircraft._state)
	_ui._determine_ui_actions(_aircraft._state)
	_aircraft._update_transit_ui()
		
func _hide_all_aircraft():
	for _aircraft in _globals._fleet:
		_aircraft.visible = false

func _show_current_aircraft():
	_globals._plane = _globals._fleet[_globals._fleet_idx]
	_globals._fleet[_globals._fleet_idx].visible = true

func _set_switcher_info(name, state):
	#$vertical/current/name.text = name
	#$vertical/current/location.text = state
	#_fuel_indicator.text = "working"
	pass

func _update_cash_amount(val):
	if _cash_indicator != null:
		_cash_indicator.text = String(floor(val))
		_globals._cash = val

func _update_global_info(cash):
	$shade/top_value_tween.interpolate_method(self, "_update_cash_amount", _globals._cash, _globals._cash + cash, 3, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	$shade/top_value_tween.start()

func _set_aircraft_info():
	var _aircraft = _globals._fleet[_globals._fleet_idx]
	if _aircraft_count != null:
		_aircraft_count.text = String(_globals._fleet_idx + 1) + " / " + String(_globals._fleet.size())
	
	if _aircraft_name != null:
		_aircraft_name.text = _aircraft._title
		
	if _aircraft_location != null:
		_aircraft_location.text = _globals._locations[_aircraft._location]._location_name
		
	if _fuel_indicator != null:
		_fuel_indicator.text = String(_aircraft._fuel / _aircraft._tank * 100) + "%"

func _open_locations():
	#first load the correct screen and ui 
	_globals._plane._state = _globals.PLANE_STATE.DEPARTING
	_globals._map._determine_aircraft_scene(_globals._plane._state)
	_ui._determine_ui_actions(_globals._plane._state)
	_ui._depart_tutorial.visible = false
	_ui._location_switcher.visible = true
	var _locat = _globals._locations[_globals._fleet[_fleet_idx]._location]
	_globals._main_camera._target = _locat
	_ui._location_switcher._update_switcher_info(_globals._plane._location)
	
	for loc in _globals._locations:
		loc._stop_button.visible = true
		loc._texture_button.texture_normal = loc._add_sprite
	_locat._stop_button.visible = false
	_locat._stop_button
	for _aircraft in _globals._fleet:
		_aircraft.visible = false

func _aircraft_depart():
	var _aircraft = _globals._get_aircraft()
	_globals._switcher._disable_landing_actions()
	_aircraft._state = _globals.PLANE_STATE.IN_TRANSIT
	
	#distance to the next target stop
	var _distance = _globals._locations[_aircraft._location].position.distance_to(_aircraft._stops[0].position)
	var _length = floor(_distance / _aircraft._max_speed) * 60
	_aircraft._length = _length

	_globals._map._determine_aircraft_scene(_aircraft._state)
	_ui._determine_ui_actions(_aircraft._state)

func _determine_switcher_content():
	var _count = _globals._fleet.size()
	
	_no_aircraft.visible = _count < 1
	_choose_aircraft.visible = _count > 0
	_next_craft.disabled = _count < 2
	_prev_craft.disabled = _count < 2
	_depart.disabled = _count < 1
	_location.disabled = _count < 1
	if _globals._plane != null:
		_shop.disabled = _globals._plane._state == _globals.PLANE_STATE.IN_TRANSIT


func _open_customize():
	if _ui._customize != null:
		_ui._shade.visible = true
		_ui._customize.visible = true
		_ui._customize._fill_customize_data()
