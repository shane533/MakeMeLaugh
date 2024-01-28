extends Node2D

@onready var click_sound = $click_sound
var path = "res://scene_changer.tscn"

func _ready():
	update_button_texts()
	play_title_anim()
	
func play_title_anim():
	var words = [$Title/Make, $Title/America, $Title/Laugh, $Title/Again]
	for w in words:
		play_word_anim(w)
	var heads = [$Title/Head1, $Title/Head2]
	for h in heads:
		play_head_anim(h)
		
func play_word_anim(word:Sprite2D):
	var tween = create_tween()
	var duration = 0.5
	var degree = 8
	tween.tween_property(word, "rotation_degrees", degree, duration).set_ease(Tween.EASE_OUT)
	tween.tween_property(word, "rotation_degrees", -degree, duration).set_ease(Tween.EASE_OUT)
	tween.set_loops(0)
	
func play_head_anim(head:Sprite2D):
	var tween = create_tween()
	var duration = 0.5
	var degree = 20
	var y = head.position.y
	var length = 20
	tween.tween_property(head, "rotation_degrees", degree, duration).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(head, "position:y", y-length, duration)
	tween.tween_property(head, "rotation_degrees", -degree, duration).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(head, "position:y", y+length, duration)
	tween.set_loops(0)

func _on_exit_button_pressed():
	click_sound.play()
	var time2 = get_tree().create_timer(0.1)
	await time2.timeout
	get_tree().quit()

func _on_start_button_pressed():
	Global.is_2020 = true
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
	update_button_texts()
		
func update_button_texts():
	if Global.is_ZH:
		$start_button/Label.text = "MAGA!"
		$language_button/Label.text = "语言:中文"
		$exit_button/Label.text = "退出"
	else:
		$language_button/Label.text = "Lang:English"
		$exit_button/Label.text = "EXIT"
		$start_button/Label.text = "MAGA!"
