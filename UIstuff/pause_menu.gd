extends Control


@onready var pause_container = $Anchor/PauseContainer
@onready var level_beat_container = $Anchor/LevelBeatContainer
@onready var next_level_button = $Anchor/LevelBeatContainer/VBoxContainer/Next
@export var next_level_path : String
var paused = false
var switchable = true
var unavailable : Color = Color(0.252, 0.252, 0.252)

func _input(_event):
	if switchable and Input.is_action_just_pressed("quit"):
		if paused:
			unpause()
		else:
			pause()

func quit():
	unpause()
	get_tree().change_scene_to_file("res://UIstuff/main_menu.tscn")
	switchable = true
	switch_to_beat(false)

func pause():
	paused = true
	show()
	Engine.time_scale = 0

func unpause():
	paused = false
	hide()
	Engine.time_scale = 1

func next_level():
	get_tree().change_scene_to_file(next_level_path)
	switch_to_beat(false)
	switchable = true
	unpause()

func switch_to_beat(beat : bool):
	if beat:
		pause()
	if next_level_path == "":
		next_level_button.modulate = unavailable
		next_level_button.disabled = true
	else:
		next_level_button.disabled = false
	pause_container.visible = not beat
	level_beat_container.visible = beat
	switchable = not beat
