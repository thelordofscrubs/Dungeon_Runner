extends Button

var levelId = text.lstrip("Level ")

func _pressed():
	get_node("/root/mainControlNode").startLevel(int(levelId))
