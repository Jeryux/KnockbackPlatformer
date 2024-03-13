extends Control

var paused = false

func _input(_event):
	if Input.is_action_just_pressed("quit"):
		if paused:
			unpause()
		else:
			pause()

func quit():
	unpause()
	get_tree().change_scene_to_file("res://UIstuff/main_menu.tscn")

func pause():
	paused = true
	show()
	Engine.time_scale = 0

func unpause():
	paused = false
	hide()
	Engine.time_scale = 1
