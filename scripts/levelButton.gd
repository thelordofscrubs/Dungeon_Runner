extends Button

var levelId = text.lstrip("Level ")

func _pressed():
	get_parent().startLevel(levelId)
