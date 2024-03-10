extends CharacterBody2D

@export var starter_to_right = true
var going_right

@onready var movement_manager = $MovementManager
@onready var right_cast = $RightCast
@onready var left_cast = $LeftCast
@onready var sprite = $AnimatedSprite2D

func _ready():
	going_right = starter_to_right
	movement_manager.set_move_direction(1 if going_right else -1)
	sprite.flip_h = going_right

func _physics_process(_delta):
	if is_on_wall():
		left_cast.enabled = true
		right_cast.enabled = true
		left_cast.force_raycast_update()
		right_cast.force_raycast_update()
		if left_cast.is_colliding() or right_cast.is_colliding():
			going_right = not right_cast.is_colliding()
			movement_manager.set_move_direction(1 if going_right else -1)
			sprite.flip_h = going_right
	move_and_slide()
