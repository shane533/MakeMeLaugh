extends Node2D


@export var path = 1
@export var vec_player_first = Vector2(540,520)
@export var vec_player_second = Vector2(175,520)
@export var v_player = 200
@export var vec_enemy_first = Vector2(740,520)
@export var vec_enemy_second = Vector2(1080,520)
@export var v_enemy = 200
@onready var player_sprite2D = $PlayerSprite2D
@onready var enemy_sprite2D = $EnemySprite2D


func _ready():
	player_sprite2D.position.x = -125
	enemy_sprite2D.position.x = 1380

func _process(delta):
	if path == 1:
		var pos = player_sprite2D.position.move_toward(vec_player_first,delta*v_player)
		player_sprite2D.position = pos
		pos = enemy_sprite2D.position.move_toward(vec_enemy_first,delta*v_enemy)
		enemy_sprite2D.position = pos
	elif path == 2:
		player_sprite2D.scale.x = -5
		enemy_sprite2D.scale.x = 5
		var pos = player_sprite2D.position.move_toward(vec_player_second,delta*v_player)
		player_sprite2D.position = pos
		pos = enemy_sprite2D.position.move_toward(vec_enemy_second,delta*v_enemy)
		enemy_sprite2D.position = pos
	elif path == 3:
		player_sprite2D.scale.x = 5
		enemy_sprite2D.scale.x = -5

	if player_sprite2D.position.x == 540:
		player_sprite2D.play("punch")
		var time1 = get_tree().create_timer(1)
		await time1.timeout
		path = 2
	elif player_sprite2D.position.x == 175:
		player_sprite2D.play("idle")
		path = 3
	else:
		player_sprite2D.play("walk")
	if enemy_sprite2D.position.x == 740:
		enemy_sprite2D.play("punch")
	elif enemy_sprite2D.position.x == 1080:
		enemy_sprite2D.play("idle")
	else:
		enemy_sprite2D.play("walk")
	
	#elif player_sprite2D.position.x == 175:
		#player_sprite2D.play("idle")
