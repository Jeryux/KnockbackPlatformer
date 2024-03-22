extends Control

@export var level_name : String
@export var level_scene_path : String
@onready var button : Button = $Button

var unavailable : Color = Color(0.252, 0.252, 0.252)
var usable = true

func _ready():
	button.set_text(level_name)
	if level_scene_path == "":
		usable = false
		button.modulate = unavailable
		button.disabled = true


func _on_button_pressed():
	if usable:
		get_tree().change_scene_to_file(level_scene_path)
