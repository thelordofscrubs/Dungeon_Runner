extends Sprite

func _init():
	position = OS.window_size/Vector2(2,2)
	scale = OS.window_size+Vector2(100,100)
	z_index = -1