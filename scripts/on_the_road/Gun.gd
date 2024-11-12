class_name Gun
extends Node2D

@export var spriteAnchor: Node2D
@export var bulletPrefab: PackedScene
@export var bulletSpawner: Node2D
@export var bulletsNode: Node2D

@export var gunshotsNode: Node2D
@export var playerGunshotPrefab: PackedScene

@export var woodenAmmoLabel: Label
@export var metalAmmoLabel: Label

var baseRotation: float
var orientation: int
var launchPoint: Vector2

var additionalRotation: float = PI/3
var rotationSpeed: float = PI/6

var boundPlayer: Player
signal onPlayerUnbind()


var shotDelay: float = 0.1
var timeSinceLastShot: float
var woodenAmmo: int
var metalAmmo: int = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	if rotation == 0: orientation = -1
	else: orientation = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeSinceLastShot += delta
	if boundPlayer != null:
		if orientation == 1:
			if boundPlayer.isInputJustPressed(boundPlayer.leftInput):
				unbindPlayer()
			else:
				if boundPlayer.isInputPressed(boundPlayer.rightInput):
					if timeSinceLastShot > shotDelay: shoot()
				if boundPlayer.isInputPressed(boundPlayer.upInput):
					spriteAnchor.rotation -= rotationSpeed*delta
				if boundPlayer.isInputPressed(boundPlayer.downInput):
					spriteAnchor.rotation += rotationSpeed*delta
		elif orientation == -1:
			if boundPlayer.isInputJustPressed(boundPlayer.rightInput):
				unbindPlayer()
			else:
				if boundPlayer.isInputPressed(boundPlayer.leftInput):
					if timeSinceLastShot > shotDelay: shoot()
				if boundPlayer.isInputPressed(boundPlayer.downInput):
					spriteAnchor.rotation -= rotationSpeed*delta
				if boundPlayer.isInputPressed(boundPlayer.upInput):
					spriteAnchor.rotation += rotationSpeed*delta

	spriteAnchor.rotation = clampf(spriteAnchor.rotation, baseRotation-additionalRotation, baseRotation+additionalRotation)

	woodenAmmoLabel.text = "x" + str(woodenAmmo)
	metalAmmoLabel.text = "x" + str(metalAmmo)


func bindPlayer(player: Player):
	boundPlayer = player
	timeSinceLastShot = 0

func unbindPlayer():
	boundPlayer = null
	onPlayerUnbind.emit()

func shoot():
	timeSinceLastShot = 0
	if metalAmmo > 0:
		metalAmmo -= 1
		var newBullet: Bullet = bulletPrefab.instantiate()
		bulletsNode.add_child(newBullet)
		newBullet.damage = 10
		newBullet.global_position = bulletSpawner.global_position
		newBullet.linear_velocity = Vector2(400, 0).rotated(randf_range(-0.1,0.1) + spriteAnchor.rotation)*orientation
		gunshotsNode.add_child(playerGunshotPrefab.instantiate())
	elif woodenAmmo > 0:
		woodenAmmo -= 1
		var newBullet: Bullet = bulletPrefab.instantiate()
		bulletsNode.add_child(newBullet)
		newBullet.damage = 5
		newBullet.global_position = bulletSpawner.global_position
		newBullet.linear_velocity = Vector2(200, 0).rotated(randf_range(-0.3,0.3) + spriteAnchor.rotation)*orientation
		newBullet.color = Color.SADDLE_BROWN
		gunshotsNode.add_child(playerGunshotPrefab.instantiate())
	else:
		pass
