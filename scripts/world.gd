extends Node2D

func _ready():
	_globals._world = self
	_globals._load_world()
