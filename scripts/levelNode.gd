extends Node2D
class_name Dungeon

var levelID
var levelTileMap
var levelDimensions
var levelGrid = {}
var doors = {}
var monsters = {}
var chests = {}
var keys = {}
var pots = {}
var initPlayerCoords = Vector2(1,1)
var graphicsContainerNode
var spriteContainerNode
var currentPlayerCoordinates
var pixelMult = Vector2(32,32)
var playerNode
var levelNode
var isDead = false

func _init(id = 0):
	levelID = id
	name = "level"+str(levelID)
	set_pause_mode(1)

func _ready():
	graphicsContainerNode = get_node("graphicsContainer")
	spriteContainerNode = graphicsContainerNode.get_node("spriteContainer")
	var levelName = "res://maps/map"+str(levelID)+"TileMap.tscn"
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
	print(str(levelDimensions))
	### NEW X AND Y FROM HERE ###
	for y in range(levelDimensions[1]):
		for x in range(levelDimensions[0]):
			if levelTileMap.get_cell(x,y) == 6:
				initPlayerCoords = Vector2(x,y)#need player coordinates for spawning sprites in correct locations
				currentPlayerCoordinates = initPlayerCoords
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
					levelGrid[cc] = "floor"
					levelTileMap.set_cellv(cc,0)
				7: #blueSlimeSpawn
					levelGrid[cc] = "floor"
					var facing = "up"
					spawnMonster("blueSlime",cc,initPlayerCoords,facing)
					levelTileMap.set_cellv(cc,0)
				8: #keySpawn
					levelGrid[cc] = "key"
					spawnKey(cc)
					levelTileMap.set_cellv(cc,0)
				9: #potSpawn
					levelGrid[cc] = "pot"
					spawnPot(cc)
					levelTileMap.set_cellv(cc,0)
				10: #batSkeletonSpawn
					levelGrid[cc] = "floor"
					var facing = "up"
					spawnMonster("batSkeleton",cc,initPlayerCoords,facing)
					levelTileMap.set_cellv(cc,0)
	print("initial player coordinates are: "+str(initPlayerCoords[0])+", "+str(initPlayerCoords[1]))
	levelTileMap.set_position(levelTileMap.get_position()-initPlayerCoords*Vector2(16,16))
	levelTileMap.set_z_index(0)
	playerNode = Player.new(initPlayerCoords)
	add_child(playerNode)
	playerNode.genSprite()
	graphicsContainerNode.add_child(levelTileMap)
	#get_node("healthBar").set_position()
	graphicsContainerNode.set_position(OS.get_window_size()/Vector2(2,2)-Vector2(8,8))
 
func spawnMonster(type,coordinates,playerCoords,facing):
	match type:
		"blueSlime":
			monsters[coordinates] = blueSlime.new(coordinates, facing, playerCoords)
			add_child(monsters[coordinates])
		"batSkeleton":
			pass

func spawnKey(coordinates):
	keys[coordinates] = true
	var keySprite = load("res://sprites/keySprite.tscn").instance()
	keySprite.set_position(Vector2(16,16)*(coordinates-currentPlayerCoordinates))
	keySprite.set_name(str(coordinates))
	spriteContainerNode.add_child(keySprite)

func spawnPot(coordinates):
	pots[coordinates] = true

func spawnChest(type, coordinates):
	chests[coordinates] = type

func openChest(chestKey):
	var chest = chests[chestKey]
	match chest:
		"doubleCoin":
			playerNode.changeMoney(2)
	chests.erase(chestKey)
	levelTileMap.set_cellv(chestKey,5)

func die():
	isDead = true

func attemptMove(directionStr):
	var direction
	match directionStr:
		"up":
			direction = Vector2(0,-1)
		"down":
			direction = Vector2(0,1)
		"left":
			direction = Vector2(-1,0)
		"right":
			direction = Vector2(1,0)
	var attTilePos = currentPlayerCoordinates + direction
	var attTile = levelGrid[attTilePos]
	match attTile:
		"floor":
			move(direction)
		"chest":
			move(direction)
			openChest(attTilePos)
			levelGrid[attTilePos] = "openChest"
		"openChest":
			move(direction)
		"door":
			if doors[attTilePos] == true:
				move(direction)
			else:
				if playerNode.keys > 0:
					playerNode.changeKeys(-1)
					doors[attTilePos] = true
					move(direction)
					levelTileMap.set_cellv(attTilePos, 11)
		"key":
			keys.erase(attTilePos)
			playerNode.changeKeys(1)
			levelGrid[attTilePos] = "floor"
			move(direction)
			spriteContainerNode.get_node(str(attTilePos)).queue_free()
		"pot":
			move(direction)
		"finish":
			move(direction)
			attemptEndLevel()

func attemptEndLevel():
	if monsters.size() == 0:
		endLevel()

func endLevel():
	print("End Level")

func move(direction):
	graphicsContainerNode.set_position(graphicsContainerNode.get_position()-direction*pixelMult)
	playerNode.move(direction)
	currentPlayerCoordinates += direction
	for monsterCoords in monsters.keys():
		if monsterCoords == currentPlayerCoordinates:
			playerNode.takeDamage(monsters[monsterCoords].damage)
	for monster in monsters.values():
		monster.updatePlayerPos(direction)

func _process(delta):
	if isDead == false:
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