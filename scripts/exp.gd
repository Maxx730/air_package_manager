extends Node2D

export(float) var _difficulty: float = 0.07
export(int) var _gaps: int = 2

var _level: int = 0
var _points: int = 0
var _next: int = 0

onready var _progress = get_tree().root.get_node("world/ui/dashboard/shade/top/shade/border/content/vert/exp")
onready var _text = get_tree().root.get_node("world/ui/dashboard/shade/top/shade/border/content/vert/items/level")

var _persist = {
	"level": _level,
	"points": _points,
	"next": _next
}

func _ready():
	_globals._exp = self

func _level_for_xp(xp):
	return floor(_difficulty * sqrt(xp))

func _xp_for_level(lvl):
	return floor(pow((lvl / _difficulty), _gaps))
	
func _to_next_level():
	return _xp_for_level(_level + 1) - _xp_for_level(_level)
	
func _add_exp(xp):
	_points += xp

	if _points > _xp_for_level(_level + 1):
		_level_up()
	
	_update_level_ui()

func _level_up():
	_level += 1
	_next = _to_next_level()
	_update_level_ui()

func _update_level_ui():
	if _text != null:
		_text.text = "LVL " + String(_level)
		
	if _progress != null:
		var _difference = _xp_for_level(_level + 1) - _points
		_progress.max_value = _next
		_progress.value = _next - _difference

func _xp_for_flight(aircraft, distance):
	var _xp = distance / _level
	var _dest = _globals._locations.find(aircraft._stops[0])
	for item in aircraft._cargo:
		if item._dest == _dest:
			_xp += distance * 0.05
			
	return ceil(_xp)

func _save():
	_persist["level"] = _level
	_persist["points"] = _points
	_persist["next"] = _next
	
	return _persist

func _load(data):
	_level = data.level
	_points = data.points
	_next = data.next
	
	_update_level_ui()
