extends Button


func _pressed():
	var rootNode = get_node("/root/mainControlNode")
	var currentMap = rootNode.currentLevel
	currentMap.queue_free()
	rootNode.setLevelActive(false)
	rootNode.setIsPaused(false)
	rootNode.get_node("menuStuff/mainMenu").set_visible(true)
	get_parent().queue_free()