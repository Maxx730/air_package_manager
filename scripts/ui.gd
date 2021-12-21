extends Node

onready var _dashboard = get_node("/root/world/ui/dashboard")
onready var _switcher = get_node("/root/world/ui/dashboard/vertical")
onready var _cargo = get_node("/root/world/ui/cargo")
onready var _warehouse = get_node("/root/world/ui/warehouse")
onready var _shop = get_node("/root/world/ui/shop")
onready var _takeoff = get_node("/root/world/ui/takeoff")
onready var _shade = get_node("/root/world/ui/shade")
onready var _global_actions = get_node("/root/world/ui/dashboard/global_actions")
onready var _cancel = get_node("/root/world/ui/dashboard/global_actions/cancel_button")
onready var _confirm = get_node("/root/world/ui/dashboard/global_actions/confirm_button")
onready var _title = get_node("/root/world/ui/title")
onready var _location_switcher = get_node("/root/world/ui/location_switcher")
onready var _tutorial_1 = get_node("/root/world/ui/tutorial_1")
onready var _tutorial_2 = get_node("/root/world/ui/tutorial_2")
onready var _depart_tutorial = get_node("/root/world/ui/depart_tutorial")
onready var _cargo_tutorial = get_node("/root/world/ui/cargo_tutorial")
onready var _trip_time = get_node("/root/world/ui/dashboard/vertical/current/trip_time")
onready var _transit = get_node("/root/world/ui/dashboard/vertical/current/transit")
onready var _from_name = get_node("/root/world/ui/dashboard/vertical/current/transit/from_name")
onready var _to_name = get_node("/root/world/ui/dashboard/vertical/current/transit/to_name")
onready var _cargo_list = get_node("/root/world/ui/warehouse/margin/vertical/content/vertical/cargo_list/vert/scroll/container")               

func _ready():
	_init_close_buttons()

# initializes the events when a modal top right close button is clicked on
func _init_close_buttons():
	var _buttons = get_tree().get_nodes_in_group("close_modal")
	for _button in _buttons:
		_button.connect("pressed", self, "_close_modals")
		
func _open_modal(modal):
	_shade.visible = true
	_switcher.visible = false
	modal.visible = true

#closes all ui elements and only opens the switcher
func _close_modals():
	_shade.visible = false
	_cargo.visible = false
	_warehouse.visible = false
	_shop.visible = false
	_takeoff.visible = false
	_global_actions.visible = false
	_location_switcher.visible = false
	_switcher.visible = true

func _open_actions():
	_close_modals()
	_switcher.visible = false
	_global_actions.visible = true

func _determine_ui_actions(state):
	match state:
		_globals.PLANE_STATE.LANDED:
			_close_modals()
			_globals._switcher._enable_landing_actions()
			_trip_time.visible = false
			_transit.visible = false
		_globals.PLANE_STATE.IN_TRANSIT:
			_close_modals()
			_globals._switcher._disable_landing_actions()
			_trip_time.visible = true
			_transit.visible = true
		_globals.PLANE_STATE.DEPARTING:
			_open_actions()
