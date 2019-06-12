extends Button

func _pressed():
	var mainNode = get_node("/root/mainControlNode")
	var currentLevel = mainNode.currentLevel
	var nodeID = mainNode.levelID
	mainNode.remove_child(currentLevel)
	currentLevel.queue_free()
	mainNode.startLevel(nodeID)
	get_tree().set_pause(false)
	mainNode.isPaused = false
	get_parent().get_parent().remove_child(get_parent())
	get_parent().queue_free()
