extends Node

class_name GlobalNode

@export var is_ZH:bool = false 
@export var is_2020:bool = false

var story_1_ZH: String = "测试测试测试1"
var story_1_EN: String = "TESTTEST1"
var story_2_ZH: String = "测试测试测试1"
var story_2_EN: String = "TESTTEST2"
# Called when the node enters the scene tree for the first time.
func _ready():
	story_1_ZH = "我是川宝，你们的总统。但是！四年前，卑鄙的瞌睡乔偷走了它。在那之后，我再没笑过。"
	story_1_EN = "I’m Trumb, your president! However! Sleepy John stole it four years ago. I never laugh again after that."
	story_2_ZH = "四年了，你们知道这四年我是怎么过的吗？我要来拿回本属于我的一切！"
	story_2_EN = "FOUR years, it's been four years? Now I've come to take back everything that belong to me!"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
