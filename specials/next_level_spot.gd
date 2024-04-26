extends Area2D

@export var next_level : String

func respond(body : Node2D):
	body.pause_menu.set_next_level(next_level)
	body.pause_menu.beat()
