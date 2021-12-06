extends Camera2D

export(float) var _pan_speed = 1.0

var _target = null
var _panning = false

func _ready():
	_globals._main_camera = self
	
func _process(delta):
	if _target != null and !_panning:
		position = lerp(position, _target.position, delta)

func _reset():
	_target = null
	_panning = false
	position = Vector2.ZERO
