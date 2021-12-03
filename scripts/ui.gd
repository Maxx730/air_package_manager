extends Node

onready var _dashboard = get_node("/root/world/ui/dashboard")
onready var _switcher = get_node("/root/world/ui/dashboard/vertical")
onready var _cargo = get_node("/root/world/ui/cargo")
onready var _location = get_node("/root/world/ui/location")
onready var _shop = get_node("/root/world/ui/shop")
onready var _takeoff = get_node("/root/world/ui/takeoff")
onready var _shade = get_node("/root/world/ui/shade")

func _ready():
	_init_close_buttons()
	
func _init_close_buttons():
	var _buttons = get_tree().get_nodes_in_group("close_modal")
	for _button in _buttons:
		_button.connect("pressed", self, "_close_modals")
		
func _open_modal(modal):
	_shade.visible = true
	_switcher.visible = false
	modal.visible = true
		
func _close_modals():
	_shade.visible = false
	_cargo.visible = false
	_location.visible = false
	_shop.visible = false
	_takeoff.visible = false
	_switcher.visible = true
