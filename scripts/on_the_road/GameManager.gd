class_name GameManager
extends Node

@export var parallaxBackground: ParallaxBackground

@export var playerUIPrefab: PackedScene
@export var mobileBase: MobileBase

@export var healthBar: TextureProgressBar
@export var distanceRemainingLabel: Label

@export var treesNode: Node2D
@export var treePrefab: PackedScene

@export var trucksNode: Node2D
@export var bulletsNode: Node2D
@export var truckPrefab: PackedScene

@export var honkHonk: AudioStreamPlayer2D
@export var bgm: AudioStreamPlayer2D

var distanceToObjective: float = 600

var movement: Vector2
var horizontalOffset: float

var trees: Array[RealTree]
var averageTreeSpawnDelay: float = 15
var treeSpawnDelayVariation: float = 5
var pixelsTillNextTreeSpawn: float

var trucks: Array[Truck]
var truckSpawnDelay: float = 30
var truckSpawnDelayVariation: float = 5
var timeTillNextTruckSpawn: float = 30
var truckGroupSize: int = 2
var truckGroupSizeVariation: int = 1

var openRightTruckDestinations: Array[float]
var openLeftTruckDestinations: Array[float]

# Called when the node enters the scene tree for the first time.
func _ready():
	for player in PlayerManager.playersByInputSet.values():
		mobileBase.addPlayerUI(player)
	movement = Vector2(0,100)
	for i in range(6):
		openRightTruckDestinations.append(165 + 64*i)
		openLeftTruckDestinations.append(165 + 64*i)
	
	honkHonk.finished.connect(func(): bgm.play())
	honkHonk.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	healthBar.value = mobileBase.health
	distanceRemainingLabel.text = str(float(int(distanceToObjective))/100).pad_decimals(2) + " km"

	var speed = mobileBase.speed
	# if Input.is_action_pressed("PRIMARY_MENU_BUTTON"): speed *= 100
	movement = 50*Vector2(speed*-mobileBase.steering, speed)
	distanceToObjective -= speed*delta

	if distanceToObjective <= 200:
		truckGroupSize = 4
	elif distanceToObjective <= 400:
		truckGroupSize = 3
	elif distanceToObjective <= 600:
		truckGroupSize = 2


	# roadBackground.position += movement*delta
	parallaxBackground.scroll_base_offset += movement*delta

	horizontalOffset += movement.x*delta
	if horizontalOffset < -960: horizontalOffset += 1920
	if horizontalOffset > 960: horizontalOffset -= 1920

	if pixelsTillNextTreeSpawn <= 0:
		spawnTree()
	pixelsTillNextTreeSpawn -= movement.y*delta

	for i in range(len(trees)-1, -1, -1):
		trees[i].global_position += movement*delta
		if trees[i].global_position.y > 600:
			trees.pop_at(i).queue_free()
	
	if mobileBase.fuel <= 0: timeTillNextTruckSpawn -= delta*4
	else: timeTillNextTruckSpawn -= delta
	if timeTillNextTruckSpawn <= 0:
		if len(openLeftTruckDestinations) == 6 and len(openRightTruckDestinations) == 6:
			spawnTruckGroup(bool(randi_range(0,1)))
		elif len(openLeftTruckDestinations) == 6:
			spawnTruckGroup(true)
		elif len(openRightTruckDestinations) == 6:
			spawnTruckGroup(false)
		timeTillNextTruckSpawn = truckSpawnDelay + randf_range(-truckSpawnDelayVariation, truckSpawnDelayVariation)

	for i in range(len(trucks)-1, -1, -1):
		if trucks[i].crashed:
			trucks[i].position += movement*delta
			if trucks[i].global_position.y > 600: despawnTruck(trucks[i])
	
	if mobileBase.health <= 0: SceneManager.transitionToScene(SceneManager.Scene.GAME_OVER)
	if distanceToObjective <=0: SceneManager.transitionToScene(SceneManager.Scene.VICTORY)



func spawnTree():
	var newTree = treePrefab.instantiate() as RealTree
	var horizontalPosition: int
	if randi_range(0,1):
		@warning_ignore("narrowing_conversion")
		horizontalPosition = randi_range(-994+horizontalOffset, 68 + horizontalOffset)
	else:
		@warning_ignore("narrowing_conversion")
		horizontalPosition = randi_range(891+horizontalOffset, 1953 + horizontalOffset)
	newTree.global_position = Vector2(horizontalPosition, -60)
	treesNode.add_child(newTree)
	treesNode.move_child(newTree, 0)
	trees.append(newTree)
	pixelsTillNextTreeSpawn = averageTreeSpawnDelay + randf_range(-treeSpawnDelayVariation, treeSpawnDelayVariation)


func spawnTruckGroup(leftSide: bool):
	for i in range(randi_range(-truckGroupSizeVariation,truckGroupSizeVariation)+truckGroupSize):
		var newTruck: Truck = truckPrefab.instantiate()
		var targetYCoord: float
		var orientation: int
		if leftSide:
			targetYCoord = openLeftTruckDestinations.pick_random()
			openLeftTruckDestinations.erase(targetYCoord)
			orientation = 1
		else:
			targetYCoord = openRightTruckDestinations.pick_random()
			openRightTruckDestinations.erase(targetYCoord)
			orientation = -1
		newTruck.initialize(targetYCoord, bulletsNode, orientation)
		newTruck.position.y = targetYCoord+540
		if leftSide: newTruck.position.x = randf_range(22,110)
		else: newTruck.position.x = randf_range(850, 938)
		trucksNode.add_child(newTruck)
		newTruck.onCollection.connect(despawnTruck)
		trucks.append(newTruck)


func despawnTruck(truck: Truck):
	trucks.erase(truck)
	if truck.orientation == 1: openLeftTruckDestinations.append(truck.targetYCoord)
	else: openRightTruckDestinations.append(truck.targetYCoord)
	truck.queue_free()
