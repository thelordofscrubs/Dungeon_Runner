extends Button

var levelId = text.lstrip("Level ")

func _pressed():
	get_parent().get_parent().startLevel(int(levelId))
