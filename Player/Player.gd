extends Area2D
class_name Player

onready var animatedSprite:AnimatedSprite = $AnimatedSprite
onready var firingPositions := $FiringPositions
onready var fireDelayTimer := $FireDelayTimer
onready var invincibilityTimer := $InvincibilityTimer
onready var shieldSprite := $Shield

export var speed: float = 100
export var fireDelay:float = 0.15
var vel: Vector2 = Vector2(0,0)
var plBullet:= preload("res://Bullet/Bullet.tscn")
var life:int = 3
var damageInvincibilityTime := 0.5

func _ready():
	shieldSprite.visible = false

func _process(delta):
	# Animate
	if vel.x < 0:
		animatedSprite.play("Left")
	elif vel.x > 0:
		animatedSprite.play("Right")
	else:
		animatedSprite.play("Straight")
		
	if Input.is_action_pressed("shoot") and fireDelayTimer.is_stopped():
		fireDelayTimer.start(fireDelay)
		for child in firingPositions.get_children():
			var bullet := plBullet.instance()
			bullet.global_position = child.global_position
			get_tree().current_scene.add_child(bullet)

func _physics_process(delta):
	var dirVec: Vector2 = Vector2(0,0)

	if Input.is_action_pressed("move_left"): 
		dirVec.x = -1;
	elif Input.is_action_pressed("move_right"):
		dirVec.x = 1;
		
	if Input.is_action_pressed("move_up"):
		dirVec.y = -1;
	elif Input.is_action_pressed("move_down"):
		dirVec.y = 1;
		
	vel = dirVec.normalized() * speed
	position += (vel * delta)
	
	# Make sure we are within viewport
	var viewRect:Rect2 = get_viewport_rect()
	position.x = clamp(position.x, 0, viewRect.size.x)
	position.y = clamp(position.y, 0, viewRect.size.y)
		

func damage(amount: int):
	if !invincibilityTimer.is_stopped():
		return
	invincibilityTimer.start(damageInvincibilityTime)
	shieldSprite.visible = true
	life -= amount
	if(life <= 0):
		queue_free()


func _on_InvincibilityTimer_timeout():
	shieldSprite.visible = false
