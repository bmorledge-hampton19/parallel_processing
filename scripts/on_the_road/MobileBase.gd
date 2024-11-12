class_name MobileBase
extends Node

@export var playerUIPrefab: PackedScene
@export var playersNode: Node2D

@export var hitbox: Area2D

@export var fuelProcessor: FuelProcessor
@export var fuelTankIndicator: Node2D

@export var speedInteractor: SpeedInteractor
@export var speedInteractorIndicator: Node2D

@export var steeringInteractor: SteeringInteractor

@export var onNoFuel: AudioStreamPlayer2D
@export var onRefuel: AudioStreamPlayer2D
@export var onSpeedChange: AudioStreamPlayer2D

var players: Dictionary
var playerSpawnLocations: Array[Vector2]
var health: float = 1000
var fuel: float = 100
var fuelConsumptionTier: int
var fuelConsumptionByTier := {0:1, 1:2, 2:4}
var speedByTier := {0:0.75, 1:2, 2:3}
var speed: float: 
	get:
		if fuel > 0: return speedByTier[fuelConsumptionTier]
		else: return 0.25
var steering: int		

var justHadFuel: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	fuelProcessor.onRefuel.connect(addFuel)
	speedInteractor.onFuelConsumptionChange.connect(changeFuelConsumption)
	hitbox.body_entered.connect(onBulletHit)

	for x in range(4):
		for y in [-160, -64, 64, 160]:
			playerSpawnLocations.append(Vector2(-192+x*128, y))

func addPlayerUI(player: Player):
	var newPlayerUI: PlayerUI = playerUIPrefab.instantiate()
	newPlayerUI.instantiate(player)
	playersNode.add_child(newPlayerUI)
	players[player] = newPlayerUI
	var spawnLocation = playerSpawnLocations.pick_random()
	newPlayerUI.position = spawnLocation
	playerSpawnLocations.erase(spawnLocation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	steering = steeringInteractor.steering

	if fuel > 0:
		fuel -= fuelConsumptionByTier[fuelConsumptionTier]*delta
		justHadFuel = true
	
	if justHadFuel and fuel <= 0:
		justHadFuel = false
		onNoFuel.play()



	fuelTankIndicator.rotation = PI/9 + PI*16/9*(fuel/200)


func addFuel():
	fuel += 50
	if fuel > 200: fuel = 200
	onRefuel.play()


func changeFuelConsumption(fuelConsumptionChange: int):
	var newFuelConsumptionTier = clampi(fuelConsumptionTier+fuelConsumptionChange,0,2)
	if newFuelConsumptionTier != fuelConsumptionTier:
		fuelConsumptionTier = newFuelConsumptionTier
		if fuelConsumptionTier == 0:
			speedInteractorIndicator.rotation = PI*2/3
			onSpeedChange.bus = "PitchDown"
			onSpeedChange.volume_db = -5
			onSpeedChange.play()
		elif fuelConsumptionTier == 1:
			speedInteractorIndicator.rotation = PI
			onSpeedChange.bus = "Master"
			onSpeedChange.volume_db = 0
			onSpeedChange.play()
		if fuelConsumptionTier == 2:
			speedInteractorIndicator.rotation = PI*4/3
			onSpeedChange.bus = "PitchUp"
			onSpeedChange.volume_db = 5
			onSpeedChange.play()

func setSteering(newSteering: int):
	steering = newSteering

func onBulletHit(bullet: Node2D):
	health -= bullet.damage
	bullet.queue_free()
