extends Area2D

@export var respawn_on_right = false
@export var respawn_distance = 20
var camera_zoom

func _ready():
	active(false)

func give_respawn_pos():
	var location = global_position
	location.x += respawn_distance if respawn_on_right else -respawn_distance
	return location

func active(state : bool):
	$SelectedEffect.restart()
	$SelectedEffect.emitting = state
