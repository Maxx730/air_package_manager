extends Node2D

const ZOOM_AMOUNT = 0.25

var _is_down = false

func _ready():
	for _location in _globals._locations:
		_location.connect("_location_select", self, "_draw_trip")

func _input(event):
	if visible:
		if event is InputEventMouseButton:
			_is_down = event.pressed
			
			if event.button_index == BUTTON_WHEEL_UP and _is_down:
				_globals._main_camera.zoom -= Vector2(ZOOM_AMOUNT, ZOOM_AMOUNT)
				
			if event.button_index == BUTTON_WHEEL_DOWN and _is_down:
				_globals._main_camera.zoom += Vector2(ZOOM_AMOUNT, ZOOM_AMOUNT)
		
			_globals._main_camera.zoom = Vector2(clamp(_globals._main_camera.zoom.x, 0, 1), clamp(_globals._main_camera.zoom.x, 0, 1))
		
		if event is InputEventMouseMotion:
			if _is_down:
				_globals._main_camera._panning = true
				_globals._main_camera.position -= event.relative
				
func _draw_trip():
	$trip_line.clear_points()
	$trip_line.add_point(_globals._locations[_globals._plane._location].position)
	for _location in _globals._path:
		$trip_line.add_point(_location.position)
