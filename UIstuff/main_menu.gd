extends Control

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://world.tscn")


func _on_quit_pressed():
	get_tree().quit()
