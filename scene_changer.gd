extends Node2D

var path = "res://insulting_scene.tscn"

func _ready():
	$VideoStreamPlayer.show()
	$VideoStreamPlayer.play()
	
	
func _on_video_stream_player_finished():
	get_tree().change_scene_to_file(path)
