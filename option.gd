extends Control

class_name Option

signal s_option_selected(id:int)

var _id: int
#var _text: String

func init(id: int, text: String):
	_id = id
	$Label.text = text

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	s_option_selected.emit(_id)
	pass # Replace with function body.
