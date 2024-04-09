extends Control

@onready var pause_menu = $Anchor/MarginContainer/PauseMenu
@onready var level_beat = $Anchor/MarginContainer/LevelBeat

var next_level : String = ""

var paused = false
var finished = false

func _input(_event):
	if Input.is_action_just_pressed("quit") and not finished:
		if paused:
			unpause()
		else:
			pause()

func set_next_level(level : String):
	next_level = level

func beat():
	Engine.time_scale = 0
	pause_menu.hide()
	level_beat.show()
	show()
	finished = true
	paused = true

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

func next():
	if next_level != "":
		Engine.time_scale = 1
		get_tree().change_scene_to_file(next_level)
