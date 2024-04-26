extends CharacterBody2D

@export var starter_to_right = true
var going_right
var dead = false

@onready var movement_manager = $MovementManager
@onready var right_cast = $RightCast
@onready var left_cast = $LeftCast
@onready var sprite = $AnimatedSprite2D
@onready var death_effect = $DeathEffect
@onready var collision = $CollisionShape2D
@onready var detector = $Detector

func _ready():
	going_right = starter_to_right
	movement_manager.set_move_direction(1 if going_right else -1)
	sprite.flip_h = going_right

func orient(to_right : bool):
	going_right = to_right
	movement_manager.set_move_direction(1 if going_right else -1)
	sprite.flip_h = going_right

func _physics_process(_delta):
	if dead:
		return
	if is_on_wall():
		check_sides()
		if left_cast.is_colliding() or right_cast.is_colliding():
			going_right = not right_cast.is_colliding()
			movement_manager.set_move_direction(1 if going_right else -1)
			sprite.flip_h = going_right
	move_and_slide()

func check_sides():
	left_cast.enabled = true
	right_cast.enabled = true
	left_cast.force_raycast_update()
	right_cast.force_raycast_update()
func die():
	detector.set_deferred("monitoring", false)
	dead = true
	sprite.visible = false
	$DeathEffect.restart()
	$DeathEffect.emitting = true
	collision.set_deferred("disabled", true)
	$RemoveTimer.start()

func interact(body):
	if body.is_in_group("Player"):
		body.die()
	else:
		die()

func remove():
	queue_free()
