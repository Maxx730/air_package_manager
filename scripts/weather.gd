extends Node2D

enum WEATHER_TYPES {
	CLEAR,
	RAIN
}

onready var _rain: Particles2D = $rain

onready var _current: Particles2D = null

func _ready():
	_globals._weather = self

func _set_intensity(value):
	if _current == _rain:
		_current.process_material.initial_velocity = value
		_current.speed_scale = value / 50

func _set_type(var type: int = WEATHER_TYPES.CLEAR):
	match type:
		WEATHER_TYPES.CLEAR:
			pass
		WEATHER_TYPES.RAIN:
			pass
