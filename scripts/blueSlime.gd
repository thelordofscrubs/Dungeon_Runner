extends Node
class_name blueSlime

var spriteScene = preload("res://sprites/blueSlimeSprite.tscn")

var health = 10
var maxHealth = 10
var damage = 5
var coordinates
var facing
var playerCoordinates
var sprite
var attackTimer

func _ready():
	sprite = spriteScene.instance()
	sprite.set_position((coordinates-playerCoordinates)*Vector2(16,16))
	get_node("../graphicsContainer/spriteContainer").add_child(sprite)


func _init(c,f,pc):
	coordinates = c
	facing = f
	playerCoordinates = pc
	attackTimer = Timer.new()
	add_child(attackTimer)
	attackTimer.connect("timeout",self,"attack")
	attackTimer.start(.5)

func updatePlayerPos(vec):
	playerCoordinates += vec

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



#var attackTimer = 0
#func _process(delta):
#	attackTimer += delta
#	if attackTimer >= .5:
#		attack()
#		attackTimer = 0