extends Area2D

@export var zoom : float
@export var duration = 1.0

func _on_body_entered(body):
	body.change_zoom(duration, zoom)
