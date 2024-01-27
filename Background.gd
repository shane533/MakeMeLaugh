extends Node2D

var path = "res://insulting_scene.tscn"

func _ready():
	var label_num = $Label.get_total_character_count()
	var i = 0
	$Label.show()
	while i <= label_num:
		$Label.visible_characters = i
		i += 1
		var time1 = get_tree().create_timer(0.2)
		await time1.timeout
	var time2 = get_tree().create_timer(3)
	await time2.timeout
	self.get_tree().change_scene_to_file(path)
