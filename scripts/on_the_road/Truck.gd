class_name Truck
extends Area2D

@export var healthBar: TextureProgressBar

@export var sprite: Sprite2D

@export var bulletPrefab: PackedScene

@export var gunshotPrefab: PackedScene
@export var wreckPrefab: PackedScene

# 1 if shooting right; -1 if shooting left
var orientation: int

var health: float = 100

var targetYCoord: float
var speed: float = 100

var initialFireDelay: float = 5.5
var initialFireDelayVariation: float = 0.5
var regularFireDelay: float = 2
var regularFireDelayVariation: float = 0.25
var timeTillNextVolley: float

var truckBulletsNode: Node2D
var shooting: bool
var shotsFiredThisVolley: int
var shotDelay: float = 0.25
var timeTillNextShot: float

var crashed: bool
signal onCollection(truck: Truck)

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(onBulletHit)

func initialize(p_targetYCoord: float, p_truckBulletsNode: Node2D, p_orientation: int):
	targetYCoord = p_targetYCoord
	truckBulletsNode = p_truckBulletsNode
	orientation = p_orientation
	if orientation == -1: sprite.flip_h = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if crashed: return
	if position.y != targetYCoord:
		var movement = speed * delta
		if position.y < targetYCoord:
			position.y += movement
		elif position.y > targetYCoord:
			position.y -= movement
		if abs(targetYCoord - position.y) < movement:
			position.y = targetYCoord
			timeTillNextVolley = initialFireDelay + randf_range(-initialFireDelayVariation, initialFireDelayVariation)

	elif not shooting:
		timeTillNextVolley -= delta
		if timeTillNextVolley <= 0:
			startShooting()
	
	else:
		timeTillNextShot -= delta
		if timeTillNextShot <= 0:
			var newBullet: Bullet = bulletPrefab.instantiate()
			newBullet.damage = 5
			truckBulletsNode.add_child(newBullet)
			newBullet.global_position = global_position + Vector2(30*orientation, 0)
			newBullet.linear_velocity = Vector2(400, 0).rotated(randf_range(-0.2,0.2))*orientation
			shotsFiredThisVolley += 1
			if shotsFiredThisVolley == 5: stopShooting()
			timeTillNextShot = shotDelay
			truckBulletsNode.add_child(gunshotPrefab.instantiate())


func startShooting():
	shooting = true
	shotsFiredThisVolley = 0
	timeTillNextShot = shotDelay

func stopShooting():
	shooting = false
	timeTillNextVolley = regularFireDelay + randf_range(-regularFireDelayVariation, regularFireDelayVariation)

func onBulletHit(bullet: Node2D):
	health -= (bullet as Bullet).damage
	healthBar.value = health
	bullet.queue_free()
	if health <= 0: crash()

func crash():
	crashed = true
	healthBar.hide()
	set_collision_layer_value(2, true)
	set_collision_layer_value(5, false)
	set_collision_mask_value(6, false)
	sprite.region_rect.position = Vector2(64,0)
	truckBulletsNode.add_child(wreckPrefab.instantiate())

func collect():
	onCollection.emit(self)
