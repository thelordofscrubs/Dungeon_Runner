extends Button

var levelId = text.lstrip("Level ")

func _pressed():
	print(text+" and stripped: "+levelId)
	get_node("/root/mainControlNode").startLevel(int(levelId))
