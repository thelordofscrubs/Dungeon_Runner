extends Node
class_name blueSlime

var spriteScene = preload("res://sprites/blueSlimeSprite.tscn")

var health = 10.0
var maxHealth = 10
var damage = 5
var coordinates
var facing
var playerCoordinates
var sprite
var attackTimer
var healthBar
var moveTimer
var levelMap
var monsterID

func _ready():
	sprite = spriteScene.instance()
	sprite.set_position((coordinates-playerCoordinates)*Vector2(16,16))
	get_node("../graphicsContainer/spriteContainer").add_child(sprite)
	healthBar = monsterHealthBar.new(coordinates,maxHealth, health, name)
	healthBar.set_position((coordinates-playerCoordinates)*Vector2(16,16)+Vector2(-10,16))
	get_node("../graphicsContainer/spriteContainer").add_child(healthBar)
	


func _init(c,f,pc,id):
	name = "blueSlime"+str(id)
	monsterID = id
	coordinates = c
	facing = f
	playerCoordinates = pc
	attackTimer = Timer.new()
	add_child(attackTimer)
	attackTimer.connect("timeout",self,"attack")
	attackTimer.start(.5)
	moveTimer = Timer.new()
	add_child(moveTimer)
	moveTimer.connect("timeout",self,"attemptMove")
	moveTimer.start(1)

func getMap(map):
	levelMap = map

func attemptMove():
	var attemptedCoordinates = coordinates + facing
	if levelMap[attemptedCoordinates] == "wall":
		facing *= Vector2(-1,-1)
		move(facing, 1)
	elif levelMap[attemptedCoordinates] == "door":
		facing *= Vector2(-1,-1)
		move(facing, 1)
	else:
		move(facing, 1)

func updatePlayerPos(vec):
	playerCoordinates += vec

func changeHealth(a):
	health += a
	if health > maxHealth:
		health = maxHealth
	healthBar.set_value(health)
	if health <= 0:
		die()

func die():
	get_node("../graphicsContainer/spriteContainer").remove_child(sprite)
	sprite.queue_free()
	get_node("../graphicsContainer/spriteContainer").remove_child(healthBar)
	healthBar.queue_free()
	get_parent().killMonster(self)
	get_parent().remove_child(self)

func move(vec,time = 1):
	coordinates += vec
	#facing = vec
	sprite.move(vec)
	healthBar.move(vec, 1)
	attack()

func attack():
	if playerCoordinates == coordinates:
		get_node("../Player").takeDamage(damage)



#var attackTimer = 0
#func _process(delta):
#	attackTimer += delta
#	if attackTimer >= .5:
#		attack()
#		attackTimer = 0