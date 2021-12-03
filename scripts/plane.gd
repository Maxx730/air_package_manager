extends Node2D

enum PLANE_CLASS {
	CLASS_ONE,
	CLASS_TWO,
	CLASS_THREE
}

enum PLANE_STATE {
	LANDED,
	IN_TRANSIT,
	FUELING
}

var _sprites = [
	preload("res://assets/sprites/aircraft/cesna_generic.png"),
	preload("res://assets/sprites/aircraft/airbus_generic.png"),
	preload("res://assets/sprites/aircraft/310_generic.png"),
	preload("res://assets/sprites/aircraft/skymaster_generic.png")
]

export(String) var _title : String = 'Boeing 777F'
var _class : int = PLANE_CLASS.CLASS_ONE
var _state : int = PLANE_STATE.LANDED
var _destination : Node2D = null
var _max_speed : float = 100.0
var _weight_capactiy = 100.0
var _cargo : Array = []
var _value = 100.0
var _location = -1

func _ready():
	pass

func _process(delta):
	match _state:
		PLANE_STATE.LANDED:
			pass
		PLANE_STATE.IN_TRANSIT:
			pass

func _transit_animations(delta):
	_sway()

func _save():
	return {
		"title": _title,
		"file": filename,
		"state": _state,
		"cargo": _cargo,
		"location": _location,
		"sprite": $sprite.texture.resource_path,
		"position": {
			"x": position.x,
			"y": position.y
		}
	}

func _load(data):
	_title = data.title
	_cargo = data.cargo
	_location = data.location
	_state = data.state
	$sprite.texture = load(data.sprite)

func _get_state():
	match _state:
		0:
			return 'Landed'
		1:
			return 'In Transit'
		2:
			return 'Fueling'

func _sway():
	$sway.interpolate_property($sprite, 'position', $sprite.position, Vector2(3, $sprite.position.y), 6, Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	$sway.start()
	
func _sway_complete():
	randomize()
	$sway.interpolate_property($sprite, 'position', $sprite.position, Vector2((randi() % 6) * -1, $sprite.position.y), 6, Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	$sway.start()

func _set_lights(val):
	$sprite/lights.visible = val

func _get_sprite_texture():
	return $sprite.texture
