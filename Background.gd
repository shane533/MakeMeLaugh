extends Node2D

@export var gap = 0.2
@onready var typing = $typing
@onready var label = $Label
var path = "res://insulting_scene.tscn"

func _ready():
	if	Global.is_2020 and Global.is_ZH:
		label.text = Global.story_1_ZH
	elif Global.is_2020 and !Global.is_ZH:
		label.text = Global.story_1_EN
		gap = 0.05
	elif !Global.is_2020 and Global.is_ZH:
		label.text = Global.story_2_ZH
	elif !Global.is_2020 and !Global.is_ZH:
		label.text = Global.story_2_EN
		gap = 0.05
		
	var label_num = label.get_total_character_count()
	var i = 0
	label.show()
	while i <= label_num:
		typing.play()
		label.visible_characters = i
		i += 1
		var time1 = get_tree().create_timer(gap)
		await time1.timeout
	var time2 = get_tree().create_timer(3)
	await time2.timeout
	self.get_tree().change_scene_to_file(path)
