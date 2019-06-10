extends Control

var currentLevel
var isPaused = false


func startLevel(levelToStart):
	currentLevel = load("res://level"+str(levelToStart)+".tscn")
	#set_visible(false)
	add_child(currentLevel.instance())






func _process(delta):
	if Input.is_action_just_released("pauseMenu"):
		match isPaused:
			false:#pause
				pass
			true:#un-pause
				pass