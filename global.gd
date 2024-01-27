extends Node

class_name GlobalNode

@export var is_ZH:bool = true 
@export var is_2020:bool = true

var story_1_ZH: String = "测试测试测试1"
var story_1_EN: String = "TESTTEST1"
var story_2_ZH: String = "测试测试测试1"
var story_2_EN: String = "TESTTEST2"
# Called when the node enters the scene tree for the first time.
func _ready():
	story_1_ZH = "我是川普，我是你们的总统，但四年前，那个卑鄙的瞌睡乔偷走了我的总统。那是我永生难忘的一天"
	story_1_EN = "I am Trump, I'm your PRESIDENT，but four years ago, that Sleepy Joe stole the presidency. That's a day I'll never forget in my life."
	story_2_ZH = "四年了，你们知道这四年我是怎么过的吗？我要来拿回本属于我的一切！"
	story_2_EN = "FOUR years, it's been four years? Now I've come to take back everything that belong to me!"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
