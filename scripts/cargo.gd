extends Node2D

enum CARGO_TYPE {
	MAIL
}

var _persist = {
	"description": "Item Description",
	"weight": 0,
	"destination": -1
}

var _items = [
	"grid",
	"paper",
	"cookie",
	"jar",
	"bottle cap",
	"eraser",
	"tomato",
	"paint",
	"brush",
	"sandal",
	"thermostat",
	"spoon",
	"fridge",
	"mop",
	"photo album",
	"wallet",
	"glasses",
	"CD",
	"cat",
	"shovel",
	"tissue",
	"box",
	"phone",
	"pool stick",
	"USB drive",
	"air freshener",
	"lip gloss",
	"leg warmers",
	"deodorant",
	"twister",
	"soy sauce packet",
	"white out",
	"tv",
	"keys",
	"outlet",
	"button",
	"toothbrush",
	"stop sign",
	"computer",
	"bread",
	"buckle",
	"food",
	"plastic",
	"fork",
	"scotch",
	"tape",
	"lotion",
	"soap",
	"speakers",
	"slipper"
]

export(String) var _description : String = ""
export(float) var _weight : float = 0.00
export(int) var _dest : int = -1
export(CARGO_TYPE) var _type : int = 0

func _randomize(loc):
	randomize()
	_description = _items[randi() % _items.size()]
	_weight = rand_range(5.0, 75.0)
	
	while _dest == loc || _dest == -1:
		randomize()
		_dest = randi() % _globals._locations.size()
		if _dest != loc:
			return

func _save():
	_persist["description"] = _description
	_persist["weight"] = _weight
	_persist["destination"] = _dest
	return _persist

func _load(data):
	_description = data.description
	_weight = data.weight
	_dest = data.destination
