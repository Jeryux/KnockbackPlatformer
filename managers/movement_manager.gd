extends Node2D

@export var speed = 185
@export var base_acceleration = 30
@export var jump_power = -300
@export var gravity = 800

var acceleration

var character : CharacterBody2D
var move_dir : int

func _ready():
	character = get_parent()
	acceleration = base_acceleration

func set_move_direction(direction : int):
	move_dir = direction


func jump():
	character.velocity.y = jump_power
	character.jumping = true
	if abs(character.velocity.x) > 250:
		acceleration /= 10

func _process(delta):
	if not character.is_on_floor():
		character.velocity.y += gravity * delta
	if move_dir and (move_dir == 1 and character.velocity.x < 200) or (move_dir == -1 and character.velocity.x > -200):
		character.velocity.x = move_toward(character.velocity.x, speed * move_dir, base_acceleration)
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, acceleration)
	if character.is_on_floor():
		acceleration = base_acceleration
