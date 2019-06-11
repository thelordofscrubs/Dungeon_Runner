extends Button


func _pressed():
	var rootNode = get_parent().get_parent()
	var currentMap = rootNode.currentLevel
	currentMap.queue_free()
	rootNode.setLevelActive(false)
	rootNode.setIsPaused(false)
	get_node("../../mainMenu").set_visible(true)
	get_parent().queue_free()