extends Node2D

@export var vec_player = Vector2(175,520)
@export var v_player = 1000
@export var vec_enemy = Vector2(1080,520)
@export var v_enemy = 1000
@onready var animation_player = $AnimationPlayer
@onready var animation_enemy = $AnimationEnemy

func _ready():
	pass

func _process(delta):
	var pos = animation_player.position.move_toward(vec_player,delta*v_player)
	animation_player.position = pos
	pos = animation_enemy.position.move_toward(vec_enemy,delta*v_enemy)
	animation_enemy.position = pos
	if animation_player.position.x >= 175:
		animation_player.play("idle")
	else:
		animation_player.play("walk")
		
