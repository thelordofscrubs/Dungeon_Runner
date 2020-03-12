extends Node
class_name Player

var spriteScene = preload("res://sprites/charSprite.tscn")

var health
var mana = 100
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
var manaBar
var moneyDisplay
var keyDisplay
var arrowDisplay
var weaponDisplay
var isDead = false
#var deathAnimationFrame = 0
var attackSpeed = 1
var weapons = ["sword","bow"]
var currentWeapon = 0
var arrows = 0
var spells = ["firebolt","speed buff"]
var currentSpell = 0
var manaRegenTimer
var spellDisplay
var buffDisplay
var currentBuffs = []

func _ready():
#	sprite = spriteScene.instance()
#	sprite.set_z_index(5)
#	get_parent().add_child(sprite)
#	print("charSprite should have been generated")
	healthBar = get_node("../uiContainer/uiBackground1/healthBar")
	manaBar = get_node("../uiContainer/uiBackground1/manaBar")
	moneyDisplay = get_node("../uiContainer/uiBackground1/moneyDisplay")
	keyDisplay = get_node("../uiContainer/uiBackground1/keyDisplay")
	arrowDisplay = get_node("../uiContainer/uiBackground1/arrowDisplay")
	arrowDisplay.set_text("Arrows:\n"+str(arrows))
	weaponDisplay = get_node("../uiContainer/uiBackground1/weaponDisplay")
	spellDisplay = get_node("../uiContainer/uiBackground1/spellDisplay")
	buffDisplay = get_node("../uiContainer/uiBackground1/buffDisplay")
	manaRegenTimer = Timer.new()
	manaRegenTimer.connect("timeout", self, "regenMana")
	add_child(manaRegenTimer)
	manaRegenTimer.start(2)

func _init(spawnCoordinates, h = 100, aM = 1):
	name = "Player"
	coordinates = spawnCoordinates
	initialCoordinates = spawnCoordinates
	health = h
	atkM = aM
	totalDamage = atkS * atkM

func removeBuff(buffName):
	currentBuffs.erase(buffName)
	if currentBuffs.has(buffName):
		return
	var buffText = buffDisplay.text
	match buffName:
		"atkSpeedUp":
			var loc = buffText.find(" Attack Speed Up")
			buffText.erase(loc, 17)
			if currentBuffs.size() > 1:
				buffText.erase(1,loc)
	if currentBuffs.size() == 1:
		buffText.erase(1,buffText.find(","))
	#buffText = "Currently Active Buffs:" + buffText
	buffDisplay.set_text(buffText)

func addBuff(buffName):
	if currentBuffs.has(buffName):
		currentBuffs.append(buffName)
		return
	currentBuffs.append(buffName)
	var buffText = buffDisplay.text
	match buffName:
		"atkSpeedUp":
			if currentBuffs.size() > 1:
				buffText += ","
			buffText += " Attack Speed Up"
	buffDisplay.set_text(buffText)

func genSprite():
	sprite = spriteScene.instance()
	sprite.set_z_index(5)
	sprite.set_scale(Vector2(2,2))
	get_parent().add_child(sprite)
	print("charSprite should have been generated")

func regenMana():
	mana += 2
	manaBar.value = mana

func unlockSpell(spellName):
	spells.append(spellName)

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

func attackTimer(t):
	if isAttacking == true:
		return false
	isAttacking = true
	var timer = Timer.new()
	timer.set_one_shot(true)
	add_child(timer)
	timer.connect("timeout", self, "attackTimerTimeOut")
	var time = float(t)/attackSpeed
	#print("Starting attack timer with "+String(time)+" seconds")
	timer.start(time)
	return true

func attack():
	match weapons[currentWeapon]:
		"sword":
			if attackTimer(1) == false:
				return
			sprite.set_texture(load("res://sprites/attackingSwordSprite.tres"))
			var monsterCoords = []
			for monster in get_parent().monsters:
				monsterCoords.append(monster.coordinates)
			if monsterCoords.has(coordinates):
				var hit = get_parent().hitMonster(coordinates,float(totalDamage)/2,"melee")
				print("dealt "+str(float(totalDamage)/2)+" damage to monster at " +str(coordinates))
				return
			if monsterCoords.has(coordinates+facing):
				var hit = get_parent().hitMonster(coordinates+facing,totalDamage,"melee")
				print("dealt "+str(totalDamage)+" damage to monster at " +str(coordinates))
		"bow":
			if attackTimer(2) == false:
				return
			sprite.set_texture(load("res://sprites/attackingBowSprite.png"))
			if arrows > 0:
				fireArrow(coordinates,facing)
				changeArrows(-1)

func fireArrow(coords, direction):
	var arrow = Arrow.new(coords, direction, initialCoordinates)
	get_node("../graphicsContainer").add_child(arrow)

func changeArrows(a):
	arrows += a
	arrowDisplay.set_text("Arrows:\n"+str(arrows))

func attackTimerTimeOut():
	isAttacking = false
	sprite.set_texture(load("res://sprites/charSprite.png"))

func move(vec):
	coordinates += vec
	facing = vec
	match facing:
		Vector2(1,0):
			sprite.set_texture(load("res://sprites/charSprite1.png"))
		Vector2(0,1):
			sprite.set_texture(load("res://sprites/charSprite0.png"))
		Vector2(-1,0):
			sprite.set_texture(load("res://sprites/charSprite3.png"))
		Vector2(0,-1):
			sprite.set_texture(load("res://sprites/charSprite2.png"))

func castSpell():
	if isAttacking == true:
		return
	#sprite.set_texture(load("res://sprites/charSprite.png"))
	if mana == 0:
		return
	var spell
	match spells[currentSpell]:
		"firebolt":
			attackTimer(.5)
			if mana < 20:
				return
			spell = fireBolt.new(coordinates, facing, initialCoordinates)
			get_node("../graphicsContainer").add_child(spell)
			mana -= 20
			manaBar.value = mana
		"speed buff":
			attackTimer(1)
			if mana < 50:
				return
			mana -= 50
			attackSpeed *= 4
			#print("attackSpeed is"+String(attackSpeed))
			var timer = Timer.new()
			timer.connect("timeout", self, "speedBuffTimeout")
			timer.set_one_shot(true)
			add_child(timer)
			timer.start(10)
			addBuff("atkSpeedUp")

func speedBuffTimeout():
	attackSpeed /= 4
	removeBuff("atkSpeedUp")

func changeWeapon(d):
	currentWeapon += d
	if currentWeapon == -1:
		currentWeapon = weapons.size()-1
	if currentWeapon == weapons.size():
		currentWeapon = 0
	weaponDisplay.set_text("Current Weapon:\n"+weapons[currentWeapon].capitalize())

func changeSpell(d):
	currentSpell += d
	if currentSpell == -1:
		currentSpell = spells.size()-1
	if currentSpell == spells.size():
		currentSpell = 0
	spellDisplay.set_text("Current Spell:\n"+spells[currentSpell].capitalize())

func _process(delta):
	if Input.is_action_just_released("changeUp"):
		changeWeapon(1)
	if Input.is_action_just_released("changeDown"):
		changeWeapon(-1)
	if Input.is_action_just_released("changeUp1"):
		changeSpell(1)
	if Input.is_action_just_released("changeDown1"):
		changeSpell(-1)
