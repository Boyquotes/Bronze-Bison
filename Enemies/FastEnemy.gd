extends Enemy

var rotationRate := 50

func _process(delta):
	rotate(deg2rad(rotationRate) * delta)
