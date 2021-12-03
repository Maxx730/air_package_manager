extends Camera2D

export(float) var _pan_speed = 1.0

var _panning = false
var _focused = true

func _ready():
	_globals._main_camera = self
	
func _process(delta):
	pass
