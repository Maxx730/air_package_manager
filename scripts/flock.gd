extends Node2D

export(float) var _speed = 0.5

var _start_point

func _ready():
	_start_point = position
	_respawn()

func _process(delta):
	position += Vector2(0, 1)

func _screen_exited():
	$respawn_timer.start()

func _respawn():
	randomize()
	position = Vector2(rand_range(-120, 120), _start_point.y)
