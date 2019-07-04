extends Sprite
class_name fireBolt

var coordinates
var direction
var moveCounter = 0
#var pcoords
var timer
var moveCounter1 = 0
var levelMap = {}

func _ready():
	#print("coordinates = "+str(coordinates)+ " and graphicalContainer's coords are "+str(get_parent().get_parent().position/Vector2(16,16)))
	#position = (coordinates-get_parent().get_parent().position/Vector2(16,16))*Vector2(16,16)
	#print("real position of arrow = "+str(position))
	#global_position = pcoords-get_parent().get_parent().position
	#position -= get_parent().position
	#print("real position of arrow = "+str(global_position))
	levelMap = get_parent().get_parent().levelGrid

func _init(coords, dir, initialPlayerCoords):
	#print("arrow Spawned at "+str(coords)+", going towards Vector2"+str(dir))
	#print("real position of player = "+str(pixelCoordinates))
	coordinates = coords
	position = (coords-initialPlayerCoords)*Vector2(16,16)
	direction = dir
	#pcoords = pixelCoordinates
	centered = false
	texture = load("res://sprites/redSpellSprite.png")
	scale = Vector2(1,1)
	z_index = 50
	match direction:
		Vector2(0,-1):
			pass
		Vector2(0,1):
			flip_v = true
		Vector2(1,0):
			texture = load("res://sprites/redSpellSpriteSide.png")
		Vector2(-1,0):
			texture = load("res://sprites/redSpellSpriteSide.png")
			flip_h = true
	timer = Timer.new()
	timer.connect("timeout",self,"movePixel1")
	add_child(timer)
	timer.start(1.0/80)

func movePixel1():
	position += direction
	moveCounter1 += 1
	if moveCounter1 == 3:
		timer.stop()
		var timer1 = Timer.new()
		timer1.connect("timeout",self,"movePixel")
		add_child(timer1)
		timer1.start(1.0/30)
		coordinates += direction


func movePixel():
	moveCounter += 1
	position += direction*Vector2(2,2)
	if moveCounter == 8:
		moveCounter = 0
		coordinates += direction
		match levelMap[coordinates]:
			"wall":
				get_parent().remove_child(self)
				queue_free()
				return
			"door":
				get_parent().remove_child(self)
				queue_free()
				return
	if get_node("../..").hitMonster(coordinates,5,"fire") == 1:
			get_parent().remove_child(self)
			queue_free()


