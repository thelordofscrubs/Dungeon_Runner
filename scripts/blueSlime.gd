extends Node
class_name blueSlime

var health = 10
var maxHealth = 10
var damage = 5
var coordinates
var facing
var playerCoordinates

func _init(c,f,pc):
	coordinates = c
	facing = f
	playerCoordinates = pc

func move(vec):
	coordinates += vec
	match vec:
		Vector2(1,0):
			facing = "right"
		Vector2(0,1):
			facing = "down"
		Vector2(0,-1):
			facing = "up"
		Vector2(-1,0):
			facing = "left"


func attack():
	if playerCoordinates == coordinates:
		get_node("../Player").takeDamage(damage)

var attackTimer = 0
func _process(delta):
	attackTimer += delta
	if attackTimer >= .5:
		attack()