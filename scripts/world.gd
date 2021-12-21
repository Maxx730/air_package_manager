extends Node2D

func _ready():
	_globals._world = self
	_globals._load_world()
	_generate_cargo()

func _world_tick():
	if _globals._fleet.size() > 0:
		_move_aircraft()

func _move_aircraft():
	for _aircraft in _globals._fleet:
		if _aircraft._state == _globals.PLANE_STATE.IN_TRANSIT:
			if _aircraft._stops.size() > 0:
				_aircraft._tick()

func _generate_cargo():
	for _location in _globals._locations:
		_location._generate_cargo()
