extends AnimatedSprite

func _ready():
	playing = true
	
func _flap_complete():
	playing = false
	randomize()
	$flapper.wait_time = rand_range(5, 15)
	$flapper.start()

func _on_flapper_timeout():
	playing = true
