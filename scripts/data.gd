extends Node

const FILENAME = 'data.sav'

func _save_game():
	var _save = File.new()
	_save.open('user://' + FILENAME, File.WRITE)
	_save.store_line(to_json(_globals._save()))
		
	_save.close()

func _load_game():
	var _load = File.new()
	if _load.file_exists('user://' + FILENAME):
		_load.open('user://' + FILENAME, File.READ)
		if _load.get_position() < _load.get_len():
			var _data = _load.get_line()
			return parse_json(_data)
