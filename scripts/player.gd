extends Node
class_name Player

var spriteScene = preload("res://sprites/charSprite.tscn")

var health
var atkS = 5
var atkM
var totalDamage
var coordinates
var isAttacking = false
var sprite
var facing = "down"
var keys = 0
var money = 0
var healthBar

func _ready():
#	sprite = spriteScene.instance()
#	sprite.set_z_index(5)
#	get_parent().add_child(sprite)
#	print("charSprite should have been generated")
	healthBar = get_node("../uiContainer/healthBar")

func _init(spawnCoordinates, h = 100, aM = 1):
	name = "Player"
	coordinates = spawnCoordinates
	health = h
	atkM = aM
	totalDamage = atkS * atkM

func genSprite():
	sprite = spriteScene.instance()
	sprite.set_z_index(5)
	sprite.set_scale(Vector2(2,2))
	get_parent().add_child(sprite)
	print("charSprite should have been generated")

func changeMoney(a):
	money += a

func setAttacking(b):
	isAttacking = b

func takeDamage(d):
	health -= d
	healthBar.value = health

func changeKeys(a):
	keys += a

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