extends Node
class_name Player

var spriteScene = preload("res://sprites/charSprite.tscn")

var health
var atkS = 5
var atkM
var totalDamage
var coordinates
var initialCoordinates
var isAttacking = false
var sprite
var facing = Vector2(0,1)
var keys = 0
var money = 0
var healthBar
var moneyDisplay
var keyDisplay
var isDead = false
#var deathAnimationFrame = 0
var attackSpeed = 1
var weapons = ["sword","bow"]
var currentWeapon = 0
var arrows = 3

func _ready():
#	sprite = spriteScene.instance()
#	sprite.set_z_index(5)
#	get_parent().add_child(sprite)
#	print("charSprite should have been generated")
	healthBar = get_node("../uiContainer/uiBackground1/healthBar")
	moneyDisplay = get_node("../uiContainer/uiBackground1/moneyDisplay")
	keyDisplay = get_node("../uiContainer/uiBackground1/keyDisplay")

func _init(spawnCoordinates, h = 100, aM = 1):
	name = "Player"
	coordinates = spawnCoordinates
	initialCoordinates = spawnCoordinates
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
	moneyDisplay.set_text("Money:\n"+str(money))

func setAttacking(b):
	isAttacking = b

func takeDamage(d):
	if isDead == true:
		return
	health -= d
	healthBar.value = health
	if health > 100:
		health = 100
	if health <= 0:
		var deathTimer = Timer.new()
		isDead = true
		deathTimer.set_one_shot(true)
		deathTimer.connect("timeout",self,"die")
		add_child(deathTimer)
		deathTimer.start(3)
#		var deathAnimTimer = Timer.new()
#		deathAnimTimer.connect("timeout",self,"deathAnimation")
#		deathAnimTimer.set_name("playerDeathAnimationTimer")
#		add_child(deathAnimTimer)
#		deathAnimTimer.start(.8)
#		get_parent().die()
		deathAnimation()

func deathAnimation():
#	sprite.set_texture(load("res://sprites/charDeath"+str(deathAnimationFrame+1)+".tres"))
#	if deathAnimationFrame < 3:
#		deathAnimationFrame += 1
#	else:
#		get_node("playerDeathAnimationTimer").stop()
	sprite.set_visible(false)
	var deathAnimationScene
	deathAnimationScene = load("res://playerDeathAnimation.tscn").instance()
	deathAnimationScene.set_position(OS.window_size/Vector2(2,2)+Vector2(8,8))
	deathAnimationScene.set_frame(0)
	get_parent().add_child(deathAnimationScene)
	deathAnimationScene.play("death")
	get_parent().die()

func die():
	get_node("/root/mainControlNode/menuStuff").add_child(load("res://deathScreen.tscn").instance())
	get_node("/root/mainControlNode").pause()

func changeKeys(a):
	keys += a
	keyDisplay.set_text("Keys:\n"+str(keys))

func attack():
	match weapons[currentWeapon]:
		"sword":
			if isAttacking == true:
				return
			isAttacking = true
			var attackTimer = Timer.new()
			attackTimer.set_one_shot(true)
			attackTimer.connect("timeout",self,"attackTimerTimeOut")
			add_child(attackTimer)
			attackTimer.start(attackSpeed)
			sprite.set_texture(load("res://sprites/attackingSwordSprite.tres"))
			var monsterCoords = []
			for monster in get_parent().monsters:
				monsterCoords.append(monster.coordinates)
			if monsterCoords.has(coordinates):
				var hit = get_parent().hitMonster(coordinates,float(totalDamage)/2)
				print("dealt "+str(float(totalDamage)/2)+" damage to monster at " +str(coordinates))
				return
			if monsterCoords.has(coordinates+facing):
				var hit = get_parent().hitMonster(coordinates+facing,totalDamage)
				print("dealt "+str(totalDamage)+" damage to monster at " +str(coordinates))
		"bow":
			if isAttacking == true:
				return
			isAttacking = true
			var attackTimer = Timer.new()
			attackTimer.set_one_shot(true)
			attackTimer.connect("timeout",self,"attackTimerTimeOut")
			add_child(attackTimer)
			attackTimer.start(2)
			sprite.set_texture(load("res://sprites/attackingBowSprite.png"))
			if arrows > 0:
				fireArrow(coordinates,facing)
				arrows -= 1

func fireArrow(coords, direction):
	var arrow = Arrow.new(coords, direction, initialCoordinates)
	get_node("../graphicsContainer").add_child(arrow)

func attackTimerTimeOut():
	isAttacking = false
	sprite.set_texture(load("res://sprites/charSprite.png"))

func move(vec):
	coordinates += vec
	facing = vec

func changeWeapon(d):
	currentWeapon += d
	if currentWeapon == -1:
		currentWeapon = weapons.size()-1
	if currentWeapon == weapons.size():
		currentWeapon = 0

func _process(delta):
	if Input.is_action_just_released("changeUp"):
		changeWeapon(1)
	if Input.is_action_just_released("changeDown"):
		changeWeapon(-1)
