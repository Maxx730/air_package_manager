extends VBoxContainer

var _notif_inst = preload("res://prefabs/notification.tscn")

func _ready():
	_globals._notifications = self
	
func _add_notification(message : String, length : float = 1.0):
	var _inst = _notif_inst.instance()
	_inst._set_info(message, length)
	add_child(_inst)
