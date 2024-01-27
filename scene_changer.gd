extends Node2D

@export var vec_window = Vector2(175,57.5)
@export var v_background = 2000
@export var v_window = 2000
@export var v_building = 5000

var path = "res://insulting_scene.tscn"

func _ready():
	self._label_emergence()
	#get_tree().change_scene_to_file(path)

func _process(delta):
	var pos = $Background1.position.move_toward(Vector2.ZERO,delta*v_background)
	$Background1.position = pos
	pos = $Window.position.move_toward(vec_window,delta*v_window)
	$Window.position = pos
	pos = $Building1.position.move_toward(Vector2.ZERO,delta*v_building)
	$Building1.position = pos
	pos = $Building2.position.move_toward(Vector2.ZERO,delta*v_building)
	$Building2.position = pos
	pos = $Building3.position.move_toward(Vector2.ZERO,delta*v_building)
	$Building3.position = pos

func _label_emergence():
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

