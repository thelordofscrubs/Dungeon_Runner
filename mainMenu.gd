extends Control

var currentLevel
var isPaused = false


func startLevel(levelNodeIn):
	currentLevel = levelNodeIn
	add_child(currentLevel)
	set_visible(false)






func _process(delta):
	if Input.is_action_just_released("pauseMenu"):
		match isPaused:
			false:#pause
				pass
			true:#un-pause
				pass