extends Node2D
class_name Dungeon

var levelTileMap
var levelDimensions
var levelGrid = {}
var doors = {}
var monsters = {}
var chests = {}
var initPlayerCoords = Vector2(1,1)


func _init(id):
	set_pause_mode(1)
	##########
	var levelName = "res://map"+str(id)+"TileMap.tscn"
	levelTileMap = load(levelName).instance()
	var x
	var y
	var i = 0
	while x != -1:
		x = levelTileMap.get_cell(i,0)
		i += 1
	x = i-1
	i = 0
	while y != -1:
		y = levelTileMap.get_cell(0,i)
		i += 1
	y = i-1
	levelDimensions = Vector2(x,y)
	### NEW X AND Y FROM HERE ###
	for y in range(levelDimensions[1]):
		for x in range(levelDimensions[0]):
			if levelTileMap.get_cell(x,y) == 6:
				initPlayerCoords == Vector2(x,y)#need player coordinates for spawning sprites in correct locations
	for y in range(levelDimensions[1]):
		for x in range(levelDimensions[0]):
			var cc = Vector2(x,y)
			match levelTileMap.get_cell(x,y):
				-1:
					levelGrid[cc] = "oob"
				0:
					levelGrid[cc] = "floor"
				1:
					levelGrid[cc] = "wall"
				2:
					levelGrid[cc] = "finish"
				3:
					levelGrid[cc] = "door"
					doors[cc] = false
				4:
					levelGrid[cc] = "chest"
					spawnChest("doubleCoin",cc)
				5:
					levelGrid[cc] = "chest"
				6: #playerSpawn
					levelGrid[cc] = "player"
				7: #blueSlimeSpawn
					levelGrid[cc] = "floor"
					spawnMonster("blueSlime",cc)
				8: #keySpawn
					levelGrid[cc] = "key"
					spawnKey(cc)
				9: #potSpawn
					levelGrid[cc] = "pot"
					spawnPot(cc)
				10: #batSkeletonSpawn
					levelGrid[cc] = "floor"
					spawnMonster("batSkeleton",cc)
	

func spawnMonster(type,coordinates):
	pass

func spawnKey(coordinates):
	pass

func spawnPot(coordinates):
	pass

func spawnChest(type, coordinates):
	pass








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