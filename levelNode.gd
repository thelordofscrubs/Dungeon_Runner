extends Node2D

var levelTileMap


func _init(id):
	var levelName = "res://map"+str(id)+".tscn"
	levelTileMap = load(levelName).instance()












func attemptMove(direction):
	pass

var monsterHitTimer = 0
func _process(delta):
	monsterHitTimer += delta
	if monsterHitTimer > .75:
		#for monster in monsterArray:
		#	var dmg = monster.attack(player.getCoordinates())
		#	if dmg:
		#		player.takeDamage(dmg)
		monsterHitTimer = 0
	if Input.is_action_just_released("left"):
		attemptMove("left")
	if Input.is_action_just_released("up"):
		attemptMove("up")
	if Input.is_action_just_released("right"):
		attemptMove("right")
	if Input.is_action_just_released("down"):
		attemptMove("down")
	if Input.is_action_just_released("attack"):
		#player.attack()
		pass
	if Input.is_action_just_released("use"):
		pass