extends Sprite

func move(vec):
	position += vec*Vector2(16,16)

func takeDamage(a):
	var dmgLabel = damageLabel.new()
	dmgLabel.set_align(1)
	dmgLabel.set_text(str(a))
	var posX = dmgLabel.get_size()[0]/2-8
	dmgLabel.set_position(position+Vector2(4,5))
	dmgLabel.set_scale(Vector2(0.6,0.6))
	dmgLabel.startTimer()
	get_parent().add_child(dmgLabel)

class damageLabel:
	extends Label
	
	var age = 0
	var timer
	
	func startTimer():
		timer = Timer.new()
		timer.connect("timeout",self,"moveSelf")
		add_child(timer)
		timer.start(0.01)
	
	func moveSelf():
		rect_position -= Vector2(0,1)
		age += 1
		if age > 50:
			get_parent().remove_child(self)
			queue_free()