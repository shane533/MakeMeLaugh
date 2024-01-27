extends Control

class_name Dialog

@export var trump_icon:Sprite2D
@export var biden_icon:Sprite2D
@export var bubble_node:Node
@export var bubble:Sprite2D
@export var label:Label

func init(is_trump:bool, text:String):
	trump_icon.visible = is_trump
	biden_icon.visible = not is_trump
	bubble.scale.x = 1 if is_trump else -1
	label.text = text
	bubble_node.position.x = 0 if is_trump else 360
	#self.layout_direction = Control.LAYOUT_DIRECTION_LTR if is_trump else Control.LAYOUT_DIRECTION_RTL

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
