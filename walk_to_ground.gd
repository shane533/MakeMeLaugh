extends Node2D

@export var vec_player = Vector2(175,520)
@export var v_player = 200
@export var vec_enemy = Vector2(1080,520)
@export var v_enemy = 200
@onready var player_sprite2D = $PlayerSprite2D
@onready var enemy_sprite2D = $EnemySprite2D

func _ready():
	pass

func _process(delta):
	var pos = player_sprite2D.position.move_toward(vec_player,delta*v_player)
	player_sprite2D.position = pos
	pos = enemy_sprite2D.position.move_toward(vec_enemy,delta*v_enemy)
	enemy_sprite2D.position = pos
	if player_sprite2D.position.x >= 175:
		player_sprite2D.play("idle")
	else:
		player_sprite2D.play("walk")
	if enemy_sprite2D.position.x <= 1080:
		enemy_sprite2D.play("idle")
	else:
		enemy_sprite2D.play("walk")
