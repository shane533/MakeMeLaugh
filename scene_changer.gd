extends Node2D

@export var vec_window = Vector2(175,57.5)
@export var v_background = 2000
@export var v_window = 2000
@export var v_building = 5000

var path = "res://Background.tscn"

func _ready():
	pass

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
	if $Window.position.y < 60:
		get_tree().change_scene_to_file(path)
