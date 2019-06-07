extends Button

var levelId = text.lstrip("Level ")

func _pressed():
	var mainControlNode = get_parent()
	var level = Dungeon.instance(levelId)
	mainControlNode.startLevel(level)
