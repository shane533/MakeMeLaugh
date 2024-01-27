extends Node2D

@onready var click_sound = $click_sound
var path = "res://scene_changer.tscn"

func _on_exit_button_pressed():
	click_sound.play()
	var time2 = get_tree().create_timer(0.1)
	await time2.timeout
	get_tree().quit()

func _on_start_button_pressed():
	click_sound.play()
	var time0 = get_tree().create_timer(0.1)
	await time0.timeout
	get_tree().change_scene_to_file(path)

func _on_language_button_pressed():
	click_sound.play()
	var time1 = get_tree().create_timer(0.1)
	await time1.timeout
	if Global.is_ZH == true:
		Global.is_ZH = false
	else :
		Global.is_ZH = true
