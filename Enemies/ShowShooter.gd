extends Enemy

export var fireRate := 1.0
onready var fireTimer := $FireTimer

func _process(_delta):
	if fireTimer.is_stopped():
		fire()
		fireTimer.start(fireRate)
	
