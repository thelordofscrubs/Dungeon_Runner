extends Control

var isPaused = false
var currentLevel
var mainMenu
var levelActive = false
var pauseMenu
var menuScene = preload("menu.tscn")

func _ready():
	mainMenu = get_node("mainMenu")
	OS.set_window_maximized(true)

func setLevelActive(b):
	levelActive = b

func setIsPaused(b):
	isPaused = b

func startLevel(levelToStart):
	currentLevel = load("res://level"+str(levelToStart)+".tscn")
	currentLevel = currentLevel.instance()
	set_visible(false)
	get_parent().add_child(currentLevel)
	levelActive = true

func _process(delta):
	if Input.is_action_just_released("pauseMenu"):
		match isPaused:
			false:#pause
				if levelActive == true:
					isPaused = true
					currentLevel.set_visible(false)
					pauseMenu = menuScene.instance()
					add_child(pauseMenu)
					get_tree().set_pause(true)
			true:#un-pause
				get_tree().set_pause(false)
				isPaused = false
				currentLevel.set_visible(true)
				get_node("menu").queue_free()