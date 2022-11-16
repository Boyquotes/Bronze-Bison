extends Area2D

var pMeteorEffect := preload("res://Meteor/MeteorEffect.tscn")

export var minSpeed:float = 50
export var maxSpeed:float = 80

export var minRotationRate:float = -20
export var maxRotationRate:float = 20
export var life:int = 20

var speed:float = 0
var rotationRate:float = 0
var playerInArea:Player = null


# Called when the node enters the scene tree for the first time.
func _ready():
	speed = rand_range(minSpeed, maxSpeed)
	rotationRate = rand_range(minRotationRate, maxRotationRate)


func _physics_process(delta):
	position.y += (speed * delta)
	rotation_degrees += rotationRate * delta

func damage(amount: int):
	life -= amount
	if life <= 0:
		var effect := pMeteorEffect.instance()
		effect.position = position
		get_parent().add_child(effect)
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Meteor_area_entered(area):
	if(area is Player):
		playerInArea = area
		area.damage(1)


func _on_Meteor_area_exited(area):
	if area is Player:
		playerInArea = null

func _process(delta):
	if playerInArea != null:
		playerInArea.damage(1)
