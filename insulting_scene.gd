extends Node2D

enum GameState {
	GameStart,
	WaitForPlayerInsult,
	PlayerInsulting,
	WaitForPlayerResponse,
	PlayerResponsing,
	EnemyInsulting,
	EnemyResponsing,
	DamageSettling,
	DamageSettlePlayer,
	DamageSettleEnemy,
	GameOver
}

const LABEL_FLY_DURATION: float = 0.5

const LEFT_POS:Vector2 = Vector2(300,500)
const RIGHT_POS:Vector2 = Vector2(900, 500)
const INSULT_POS:Vector2 = Vector2(400, 150)
const RESPONSE_POS:Vector2 = Vector2(450, 200)

@export var insults_don: Array[Insult] 
@export var insults_joe: Array[Insult]
@export var responses_joe: Array[Response] 
@export var responses_don: Array[Response]
@export var insult_label: Label
@export var response_label: Label
@export var is_zh: bool = true
# 
var _player_hp: int
var _enemy_hp: int
var _is_player_go_first: bool
var _state: GameState
var _selecting_insult: Insult
var _selecting_response: Response
var _unused_insults: Array[Insult]
var _options: Array[Option]

func game_start(player_go_first:bool):
	hide_labels()
	init_hps()
	_is_player_go_first = player_go_first
	_state = GameState.GameStart
	_unused_insults = insults_don.duplicate()
	debug("Game Start")
	next_state()

func init_hps():
	_player_hp = 3
	_enemy_hp = 3
	update_hp_labels()
	
func update_hp_labels():
	$PlayerHPLabel.text = "HP: %d" % _player_hp
	$EnemyHPLabel.text = "HP: %d" % _enemy_hp	

func hide_labels():
	insult_label.visible = false
	response_label.visible = false
	
func idle_characters():
	$PlayerSprite2D.play("idle")
	$EnemySprite2D.play("idle")

func clear_options():
	for op in _options:
		$OptionContainer.remove_child(op)
		op.queue_free()
	_options.clear()
	
func wait_for_player_insult() -> GameState:
	hide_labels()
	idle_characters()
	_unused_insults.shuffle()
	clear_options()
	for i in range(3):
		make_one_option(_unused_insults[i]._id, get_insult_content(_unused_insults[i]))
	debug("Wait for player insult")
	return GameState.WaitForPlayerInsult
	
func wait_for_player_response() -> GameState:
	clear_options()
	var res:Response = get_response_by_id(_selecting_insult._responses[0]) 
	var candis = responses_don.duplicate()
	candis.erase(res)
	candis.shuffle()
	var out = candis.slice(0, 2)
	out.push_back(res)
	out.shuffle()
	for i in range(3):
		make_one_option(out[i]._id, get_response_content(out[i]))
	debug("Wait for player response")
	return GameState.WaitForPlayerResponse

func enemy_insult():
	hide_labels()
	idle_characters()
	_selecting_insult = insults_joe.pick_random()
	init_insult_label(_selecting_insult, false)
	debug("Enemy Insult")
	var tween = create_tween()
	tween.tween_property(insult_label, "scale", Vector2(1.5, 1.5), LABEL_FLY_DURATION)
	tween.parallel().tween_property(insult_label, "position", INSULT_POS, LABEL_FLY_DURATION)
	tween.tween_interval(1)
	tween.tween_callback(finish_insulting)
	
func player_insulting() -> GameState:
	init_insult_label(_selecting_insult, true)
	var tween = create_tween()
	tween.tween_property(insult_label, "scale", Vector2(1.5, 1.5), LABEL_FLY_DURATION)
	tween.parallel().tween_property(insult_label, "position", INSULT_POS, LABEL_FLY_DURATION)
	tween.tween_interval(1)
	tween.tween_callback(finish_insulting)
	return GameState.PlayerInsulting
	
func enemy_responsing() -> GameState:
	#if enemy must won
	var res_id = _selecting_insult._responses[0]
	_selecting_response = get_response_by_id(res_id)
	init_response_label(_selecting_response, false)
	var tween = create_tween()
	tween.tween_property(response_label, "scale", Vector2(1.5, 1.5), LABEL_FLY_DURATION)
	tween.parallel().tween_property(response_label, "position", RESPONSE_POS, LABEL_FLY_DURATION)
	tween.tween_interval(1)
	tween.tween_callback(finish_responsing)
	return GameState.EnemyResponsing
	
func player_responsing() -> GameState:
	init_response_label(_selecting_response, true)
	var tween = create_tween()
	tween.tween_property(response_label, "scale", Vector2(1.5, 1.5), LABEL_FLY_DURATION)
	tween.parallel().tween_property(response_label, "position", RESPONSE_POS, LABEL_FLY_DURATION)
	tween.tween_interval(1)
	tween.tween_callback(finish_responsing)
	return GameState.PlayerResponsing
	
func finish_insulting():
	debug("finish_insulting")
	next_state()
	
func finish_responsing():
	debug("finish responsing")
	next_state()

func init_insult_label(ins: Insult, from_left: bool):
	insult_label.visible = true
	insult_label.text = get_insult_content(ins)
	insult_label.position = LEFT_POS if from_left else RIGHT_POS
	insult_label.scale = Vector2(0.2, 0.2)
	
func init_response_label(res: Response, from_left: bool):
	response_label.visible = true
	response_label.text = get_response_content(res)
	response_label.position = LEFT_POS if from_left else RIGHT_POS
	response_label.scale = Vector2(0.2, 0.2)

func next_state():
	match _state:
		GameState.GameStart:
			debug("GameStart Checking who go first")
			if _is_player_go_first:
				_state = wait_for_player_insult()
			else:
				_state = enemy_insult()
		GameState.WaitForPlayerInsult:
			debug("go player insult")
			_state = player_insulting()
		GameState.PlayerInsulting:
			debug("go enemy response")
			_state = enemy_responsing()
		GameState.WaitForPlayerInsult:
			debug("go player response")
			_state = player_responsing()
		GameState.PlayerResponsing:
			_state = settle_damage(false)
			debug("go damage settle")
		GameState.EnemyInsulting:
			debug("go wait for player")
			_state = wait_for_player_response()
		GameState.EnemyResponsing:
			debug("go damage settle")
			_state = settle_damage(true)
		GameState.DamageSettling:
			if is_game_over():
				_state = game_over()
				debug("Game OVER")
			else:
				_is_player_go_first = not _is_player_go_first
				if _is_player_go_first:
					_state = wait_for_player_insult()
				else:
					_state = enemy_insult()
			debug("SettlingDamage")
		GameState.DamageSettlePlayer:
			debug("go game over or wait for player insult")
		GameState.DamageSettleEnemy:
			debug("go game over or enemy insult")

func is_game_over() -> bool:
	return _player_hp == 0 or _enemy_hp == 0
	
func game_over() -> GameState:
	var sprite:AnimatedSprite2D = $PlayerSprite2D if _player_hp == 0 else $EnemySprite2D
	sprite.play("die")
	return GameState.GameOver

func settle_damage(is_player_insult: bool) -> GameState:
	var response_win: bool = _selecting_insult._responses.has(_selecting_response._id)
	if (response_win and is_player_insult) or (not response_win and (not is_player_insult)):
		character_hurt(true)
	else:
		character_hurt(false)
		
	return GameState.DamageSettling
	
func character_hurt(is_player:bool):
	var sprite:AnimatedSprite2D = $PlayerSprite2D if is_player else $EnemySprite2D
	if is_player:
		_player_hp -= 1
	else:
		_enemy_hp -= 1
	update_hp_labels()
	sprite.play("hurt")
	var tween = create_tween()
	tween.tween_interval(1)
	tween.tween_callback(finish_damage_settling)
	
func finish_damage_settling():
	next_state()
	

#only for test
func prepare_options():
	#TODO
	debug("Prepare Options")
	for i in range(3):
		var id = i
		var text = "test text %d" % id
		make_one_option(id, text)

func make_one_option(id:int, text:String):
	var s = load("res://option_button.tscn")
	var option = s.instantiate()
	option.init(id, text)
	option.s_option_selected.connect(on_option_selected)
	$OptionContainer.add_child(option)
	_options.push_back(option)

func on_option_selected(id):
	debug("Option %d Selected!" % id)
	if _state == GameState.WaitForPlayerInsult:
		_selecting_insult = get_insult_by_id(id)
		next_state()
	elif _state == GameState.WaitForPlayerResponse:
		_selecting_response = get_response_by_id(id)
		next_state()

func get_insult_by_id(id) -> Insult:
	for ins in insults_don:
		if ins._id == id:
			return ins
	for ins in insults_joe:
		if ins._id == id:
			return ins
			
	return null

func get_response_by_id(id) -> Response:
	for res in responses_joe:
		if res._id == id:
			return res
	for res in responses_don:
		if res._id == id:
			return res
			
	return null	
	
func get_insult_content(ins:Insult) -> String:
	if is_zh:
		return ins._contentZH
	else:
		return ins._contentEN
	
func get_response_content(res:Response) -> String:
	if is_zh:
		return res._contentZH
	else:
		return res._contentEN
# Called when the node enters the scene tree for the first time.
func _ready():
	#prepare_options()
	game_start(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func debug(str: String):
	print( "[%d] %s" %[ Time.get_ticks_msec() ,str])
