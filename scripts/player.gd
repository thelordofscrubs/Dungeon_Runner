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


func _init(spawnCoordinates, h = 100, aM = 1):
	name = "Player"
	coordinates = spawnCoordinates
	health = h
	atkM = aM
	totalDamage = atkS * atkM
	sprite = spriteScene.instance()
	get_node("../graphicsContainer/spriteContainer").add_child(sprite)

func takeDamage(d):
	health -= d

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