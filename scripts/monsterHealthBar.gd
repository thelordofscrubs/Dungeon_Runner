extends "res://scripts/healthBar.gd"
class_name monsterHealthBar

var coords = Vector2(1,1)

func _init(iCoords, maxV, cv, mname):
	self.name = mname + "HealthBar"
	self.max_value = maxV
	self.value = cv
	self.coords = iCoords * Vector2(16,16)
	self.rect_size = Vector2(217,27)
	self.rect_scale = Vector2(.15,.07)
	self.rect_position = Vector2(self.coords[0]-(rect_size[0]*rect_scale[0]-32)/2,self.coords[1]+32)
	#var centerPixel = self.coords
	var centerOfScreen = OS.window_size/Vector2(2,2)
	rect_position += centerOfScreen + Vector2(16,16)
	self.texture_under = preload("res://otherArt/healthBarBackground.png")
	self.texture_progress = preload("res://otherArt/healthBarForeground.png")

func move(vec):
	coords += vec
	self.rect_position += vec*Vector2(16,16)

