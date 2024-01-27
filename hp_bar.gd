extends Sprite2D

class_name HPBar

@export var _hps:Array[TextureRect] 

func update_hp(hp: int):
	print("UPDATE HP %d" % hp)
	var tween = create_tween()
	for i in range(len(_hps)):
		if i+1 > hp:
			tween.parallel().tween_property(_hps[9-i], "modulate:a", 0.3, 0.5).set_ease(Tween.EASE_OUT)
		else:
			tween.parallel().tween_property(_hps[9-i], "modulate:a", 1, 0.5).set_ease(Tween.EASE_IN)
		if i == hp:
			var pos = _hps[9-i].position
			#tween.parallel().tween_property(_hps[9-i], "position", pos, 0.5).set_trans(Tween.TRANS_BOUNCE)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
