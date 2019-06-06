extends Button

var levelId = text.lstrip("Level ")

func _pressed():
	var mainControlNode = get_parent()
	var level = load("res://levelNode.gd").instance(levelId)
	mainControlNode.startLevel(level)
