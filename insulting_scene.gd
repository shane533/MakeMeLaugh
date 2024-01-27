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
	GameOver
}

const LABEL_FLY_DURATION: float = 0.5

const LEFT_POS:Vector2 = Vector2(300,500)
const RIGHT_POS:Vector2 = Vector2(900, 500)
const INSULT_POS:Vector2 = Vector2(400, 150)
const RESPONSE_POS:Vector2 = Vector2(450, 200)

@export var insults_don: Array[Insult] 
@export var insults_joe_2020: Array[Insult]
@export var insults_joe_2024: Array[Insult]
@export var responses_joe: Array[Response] 
@export var responses_don: Array[Response]
@export var default_responses_don: Array[Response]
@export var default_responses_joe: Array[Response]
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
var _is_ticking: bool
var _left_audiences:Array[AnimatedSprite2D]
var _right_audiences:Array[AnimatedSprite2D]
var _is_2020: bool = true# 2020 is a war meant to lose

func game_start(player_go_first:bool):
	hide_game_over_panel()
	stop_ticking()
	hide_labels()
	init_hps()
	_is_player_go_first = player_go_first
	_state = GameState.GameStart
	_unused_insults = insults_don.duplicate()
	debug("Game Start")
	next_state()
	
func hide_game_over_panel():
	$GameOverPanel.visible = false

func init_hps():
	_player_hp = 5
	_enemy_hp = 5
	update_hp_labels()
	
func update_hp_labels():
	$PlayerHPLabel.text = "HP: %d" % _player_hp
	$EnemyHPLabel.text = "HP: %d" % _enemy_hp
	var tween = create_tween()
	tween.tween_property($PlayerHPBar, "value", _player_hp, 1)
	tween.parallel().tween_property($EnemyHPBar, "value", _enemy_hp, 1)


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
	if len(_unused_insults) < 3:
		_unused_insults = insults_don.duplicate()
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
	start_ticking()
	return GameState.WaitForPlayerResponse

func start_ticking():
	_is_ticking = true
	$OptionContainer/ProgressBar.visible = true
	$OptionContainer/ProgressBar.value = 0

func stop_ticking():
	_is_ticking = false
	$OptionContainer/ProgressBar.visible = false
	$OptionContainer/ProgressBar.value = 0

func enemy_insulting() -> GameState:
	hide_labels()
	idle_characters()
	if _is_2020:
		_selecting_insult = insults_joe_2020.pick_random()
		insults_joe_2020.erase(_selecting_insult)
	else:
		_selecting_insult = insults_joe_2024.pick_random()
	init_insult_label(_selecting_insult, false)
	debug("Enemy Insult")
	$EnemySprite2D.play("talk")
	$PlayerSprite2D.play("idle")
	var tween = create_tween()
	tween.tween_property(insult_label, "scale", Vector2(1.5, 1.5), LABEL_FLY_DURATION)
	tween.parallel().tween_property(insult_label, "position", INSULT_POS, LABEL_FLY_DURATION)
	tween.tween_callback(audiences_cheer)
	tween.tween_interval(1)
	tween.tween_callback(finish_insulting)
	return GameState.EnemyInsulting
	
func player_insulting() -> GameState:
	clear_options()
	init_insult_label(_selecting_insult, true)
	$PlayerSprite2D.play("talk")
	$EnemySprite2D.play("idle")
	var tween = create_tween()
	tween.tween_property(insult_label, "scale", Vector2(1.5, 1.5), LABEL_FLY_DURATION)
	tween.parallel().tween_property(insult_label, "position", INSULT_POS, LABEL_FLY_DURATION)
	tween.tween_callback(audiences_cheer)
	tween.tween_interval(2)
	tween.tween_callback(finish_insulting)
	return GameState.PlayerInsulting
	
func enemy_responsing() -> GameState:
	#if enemy must won
	if _is_2020 or randi()%2==0:
		var res_id = _selecting_insult._responses[0]
		_selecting_response = get_response_by_id(res_id)
	else:
		_selecting_response = default_responses_joe.pick_random()
	init_response_label(_selecting_response, false)
	$EnemySprite2D.play("talk")
	$PlayerSprite2D.play("idle")
	var tween = create_tween()
	tween.tween_property(response_label, "scale", Vector2(1.5, 1.5), LABEL_FLY_DURATION)
	tween.parallel().tween_property(response_label, "position", RESPONSE_POS, LABEL_FLY_DURATION)
	tween.tween_callback(audiences_cheer)
	tween.tween_interval(1)
	tween.tween_callback(finish_responsing)
	return GameState.EnemyResponsing
	
func player_responsing() -> GameState:
	clear_options()
	init_response_label(_selecting_response, true)
	$PlayerSprite2D.play("talk")
	$EnemySprite2D.play("idle")
	var tween = create_tween()
	tween.tween_property(response_label, "scale", Vector2(1.5, 1.5), LABEL_FLY_DURATION)
	tween.parallel().tween_property(response_label, "position", RESPONSE_POS, LABEL_FLY_DURATION)
	tween.tween_callback(audiences_cheer)
	tween.tween_interval(1)
	tween.tween_callback(finish_responsing)
	#audiences_cheer()
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
				_state = enemy_insulting()
		GameState.WaitForPlayerInsult:
			debug("go player insult")
			_state = player_insulting()
		GameState.PlayerInsulting:
			debug("go enemy response")
			_state = enemy_responsing()
		GameState.WaitForPlayerResponse:
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
					_state = enemy_insulting()
			debug("SettlingDamage")

func is_game_over() -> bool:
	return _player_hp == 0 or _enemy_hp == 0
	
func game_over() -> GameState:
	var is_player_die = _player_hp == 0
	var sprite:AnimatedSprite2D = $PlayerSprite2D if is_player_die else $EnemySprite2D
	sprite.play("die")
	var sprite2:AnimatedSprite2D = $PlayerSprite2D if not is_player_die else $EnemySprite2D
	sprite2.play("use")
	final_audience_cheer(not is_player_die)
	hide_labels()
	$GameOverPanel.self_modulate.a = 0.01
	$GameOverPanel.visible = true
	var tween = create_tween()
	tween.tween_property($GameOverPanel, "self_modulate:a", 1, 0.5)
	return GameState.GameOver

func is_response_win() -> bool:
	return _selecting_insult._responses.has(_selecting_response._id)

func settle_damage(is_player_insult: bool) -> GameState:
	if (is_response_win() and is_player_insult) or (not is_response_win() and (not is_player_insult)):
		character_hurt(true)
	else:
		character_hurt(false)
		
	return GameState.DamageSettling
	
func character_hurt(is_player:bool):
	var sprite:AnimatedSprite2D = $PlayerSprite2D if is_player else $EnemySprite2D
	if is_player:
		_player_hp -= 1
		_enemy_hp += 1
	else:
		_enemy_hp -= 1
		_player_hp += 1
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
		_unused_insults.erase(_selecting_insult)
		next_state()
	elif _state == GameState.WaitForPlayerResponse:
		stop_ticking()
		_selecting_response = get_response_by_id(id)
		next_state()
		
func select_default_response():
	debug("Ticking select default response")
	stop_ticking()
	_selecting_response = default_responses_don.pick_random()
	next_state()

func get_insult_by_id(id) -> Insult:
	for ins in insults_don:
		if ins._id == id:
			return ins
	for ins in insults_joe_2020:
		if ins._id == id:
			return ins
	for ins in insults_joe_2024:
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
	init_audiences()
	game_start(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _is_ticking:
		$OptionContainer/ProgressBar.value += delta * (100/3)
		if $OptionContainer/ProgressBar.value >= 100:
			select_default_response()
	pass
	
func debug(str: String):
	print( "[%d] %s" %[ Time.get_ticks_msec() ,str])


func _on_button_pressed():
	game_start(randi()%2==0)
	pass # Replace with function body.
	
func init_audiences():
	debug("Init Audiences")
	var num:int = 30
	var audi_s = load("res://audience.tscn")
	for i in range(num):
		var audi = audi_s.instantiate()
		var a = randi() % 6 + 1
		var b = randi() % 6 + 1
		var x = (i%30) * 1280/30 + randi() % 32
		var y = randi() % 20 + 710
		var anim = "%d-%d" % [a, b]
		audi.animation = anim
		audi.position.x = x
		audi.position.y = y
		if i < num/2:
			_left_audiences.push_back(audi)
		else:
			_right_audiences.push_back(audi)
		$Background/Crowd.add_child(audi)

func final_audience_cheer(is_left: bool):
	var audiences = _left_audiences if is_left else _right_audiences
	for a in audiences:
		a.play(a.animation, 3)		
	$SFX/LaughSFX.play()

func audiences_cheer():
	var is_left:bool = true
	match _state:
		GameState.PlayerInsulting:
			is_left = true
			$SFX/ShockSFX.play()
		GameState.EnemyInsulting:
			is_left = false
			$SFX/ShockSFX.play()
		GameState.PlayerResponsing:
			if is_response_win():
				is_left = true
				$SFX/LaughSFX.play()
			else:
				is_left = false
				$SFX/HissSFX.play()
		GameState.EnemyResponsing:
			if is_response_win():
				is_left = false
				$SFX/LaughSFX.play()
			else:
				is_left = true
				$SFX/HissSFX.play()
	var audiences = _left_audiences if is_left else _right_audiences
	for ani in audiences:
		ani.play(ani.animation, 3)
	var tween = create_tween()
	tween.tween_interval(1)
	tween.tween_callback(audiences_stop)
	
func audiences_stop():
	for ani in _left_audiences:
		ani.stop()
	for ani in _right_audiences:
		ani.stop()
