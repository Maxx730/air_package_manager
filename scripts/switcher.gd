extends HBoxContainer

func _ready():
	_globals._switcher = self

func _disable_landing_actions():
	$horizontal/depart.disabled = true
	$horizontal/open_location.disabled = true
	
func _enable_landing_actions():
	$horizontal/depart.disabled = false
	$horizontal/open_location.disabled = false
	$next_aircraft.disabled = _globals._fleet.size() < 2
	$prev_aircraft.disabled = _globals._fleet.size() < 2
		
