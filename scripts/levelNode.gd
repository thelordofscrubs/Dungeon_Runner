extends Node2D
class_name Dungeon

var levelTileMap
var levelDimensions
var levelGrid = {}
var doors = {}
# warning-ignore:unused_class_variable
var monsters = {}
# warning-ignore:unused_class_variable
var chests = {}
var initPlayerCoords = Vector2(1,1)
var graphicsContainerNode
var spriteContainerNode
var currentPlayerCoordinates

func _ready():
	graphicsContainerNode = get_child(0)
	spriteContainerNode = graphicsContainerNode.get_child(0)
	graphicsContainerNode.add_child(levelTileMap)

func _init(id = 0):
	set_pause_mode(1)
	position = OS.get_window_size()/Vector2(2,2)-Vector2(8,8)
	##########
	var levelName = "res://maps/map"+str(id)+"TileMap.tscn"
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
					levelGrid[cc] = "player"
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
	
	

func spawnMonster(type,coordinates,playerCoords,facing):
	match type:
		"blueSlime":
			monsters[coordinates] = blueSlime.new(coordinates, facing, playerCoords)
			add_child(monsters[coordinates])
		"batSkeleton":
			pass


# warning-ignore:unused_argument
func spawnKey(coordinates):
	pass

# warning-ignore:unused_argument
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