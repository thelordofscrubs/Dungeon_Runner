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

func _ready():
	sprite = spriteScene.instance()
	sprite.set_position((coordinates-playerCoordinates)*Vector2(16,16))
	get_node("../graphicsContainer/spriteContainer").add_child(sprite)
	healthBar = monsterHealthBar.new(coordinates,maxHealth, health, name)
	healthBar.set_position((coordinates-playerCoordinates)*Vector2(16,16)+Vector2(-15,16))
	get_node("../graphicsContainer/spriteContainer").add_child(healthBar)
	


func _init(c,f,pc,id):
	name = "blueSlime"+str(id)
	coordinates = c
	facing = f
	playerCoordinates = pc
	attackTimer = Timer.new()
	add_child(attackTimer)
	attackTimer.connect("timeout",self,"attack")
	attackTimer.start(.5)

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
	get_parent().killMonster(coordinates)
	get_parent().remove_child(self)

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