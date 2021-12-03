extends MarginContainer

func _set_information(name, price, location):
	$horizontal/vertical/name.text = name
	$horizontal/vertical/price.text = "$" + String(price)
	$horizontal/vertical/location.text = location

func _on_purchase():
	var _idx = get_index()
	var _item = _globals._available[_idx]
	if _globals._cash >= _item._value:
		_globals._cash -= _item._value
		var _move = _globals._available.slice(_idx, _idx)[0]
		_globals._fleet.append(_move)
		_globals._available.remove(_idx)
		_ui._shop._update_inventory()
		_globals._plane = _move
		get_tree().root.get_node("world").add_child(_move)
		_ui._dashboard._set_switcher_info(_move._title, _move._get_state())
		_globals._update_locations()
