extends Node2D

export(String) var _name = 'Package Name'
export(int) var _destination = -1
export(float) var _weight = 1

var _price = null

func _init():
	_weight = ceil(rand_range(1, 15))
	_destination = _globals._locations[rand_range(0, _globals._locations.size())]
	
