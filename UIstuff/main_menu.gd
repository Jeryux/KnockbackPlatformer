extends Control

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_play_pressed():
	$MarginContainer/MainControls.hide()
	$MarginContainer/LevelSelect.show()


func _on_quit_pressed():
	get_tree().quit()


func go_back():
	$MarginContainer/MainControls.show()
	$MarginContainer/LevelSelect.hide()
