extends Control

var isPaused = false
var currentLevel
var mainMenu
var levelActive = false
var pauseMenu
var menuScene = preload("res://menu.tscn")
var levelID
var menuContainer

func _ready():
	mainMenu = get_node("menuStuff/mainMenu")
	menuContainer = get_node("menuStuff")

func _init():
	#OS.set_window_maximized(true)
	pass

func setLevelActive(b):
	levelActive = b

func setIsPaused(b):
	isPaused = b

func startLevel(levelToStart):
	get_tree().set_pause(false)
	print("level id:"+str(levelToStart))
	currentLevel = load("res://level.tscn")
	currentLevel = currentLevel.instance(levelToStart)
	menuContainer.get_node("mainMenu").set_visible(false)
	add_child(currentLevel)
	levelActive = true
	levelID = levelToStart

func pause():
	levelActive = false
	get_tree().set_pause(true)
	

func _process(delta):
	if Input.is_action_just_released("pauseMenu"):
		match isPaused:
			false:#pause
				if levelActive == true:
					isPaused = true
					currentLevel.set_visible(false)
					menuContainer.set_visible(true)
					pauseMenu = menuScene.instance()
					menuContainer.add_child(pauseMenu)
					get_tree().set_pause(true)
			true:#un-pause
				get_tree().set_pause(false)
				isPaused = false
				currentLevel.set_visible(true)
				menuContainer.get_node("menu").set_visible(false)
				get_node("menuStuff/menu").queue_free()