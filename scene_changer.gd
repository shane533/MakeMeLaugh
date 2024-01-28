extends Node2D

@export var vec_window = Vector2(175,57.5)
@export var v_background = 2000
@export var v_window = 2000
@export var v_building = 5000
@onready var background1 = $Background1
@onready var building1 = $Building1
@onready var building2 = $Building2
@onready var building3 = $Building3
@onready var window = $Window

var path = "res://Background.tscn"

func _ready():
	background1.position = Vector2(0,-720)
	window.position = Vector2(175,720)
	building1.position = Vector2(-1280,0)
	building2.position = Vector2(1280,0)
	building3.position = Vector2(-1280,0)

func _process(delta):
	var pos = background1.position.move_toward(Vector2.ZERO,delta*v_background)
	background1.position = pos
	if background1.position == pos:
		pos = building1.position.move_toward(Vector2.ZERO,delta*v_building)
		building1.position = pos
		pos = building2.position.move_toward(Vector2.ZERO,delta*v_building)
		building2.position = pos
		pos = building3.position.move_toward(Vector2.ZERO,delta*v_building)
		building3.position = pos
	if building1.position == pos:
		pos = window.position.move_toward(vec_window,delta*v_window)
		window.position = pos
	if window.position.y < 60:
		get_tree().change_scene_to_file(path)


