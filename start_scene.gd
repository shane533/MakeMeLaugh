extends Node2D

var path = "res://scene_changer.tscn"
	
func _on_start_button_pressed():
	get_tree().change_scene_to_file(path)
	

func _on_exit_button_pressed():
	get_tree().quit()
