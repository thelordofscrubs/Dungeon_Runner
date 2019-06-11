extends TextureProgress

func _init(v = 100):
	value = v
	rect_position = Vector2(OS.window_size[0]/2-208,-30)

#func changeValue(v):
#	set_value(v)