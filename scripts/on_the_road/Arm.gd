class_name Arm
extends Node2D

enum Cardinals {UP, RIGHT, DOWN, LEFT}

@export var collider: Area2D
@export var sprite: Sprite2D
@export var trail: Line2D
@export var grabbedMaterialSprite: Sprite2D

var baseRotation: float
var orientation: Cardinals
var launchPoint: Vector2

var additionalRotation: float = PI/4
var rotationSpeed: float = PI/6

var boundPlayer: Player
var retrievedMaterial: PlayerUI.Carriable
signal onPlayerUnbind(retrievedMaterial: PlayerUI.Carriable)


var launchTime: float = 1
var timeSinceLaunch: float
var launchSpeed: float = 150
var retractSpeed: float:
	get:
		return launchSpeed / 2
var launching: bool
var retracting: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	baseRotation = rotation
	if baseRotation == 0: orientation = Cardinals.RIGHT
	else: orientation = Cardinals.LEFT
	launchPoint = global_position
	collider.area_entered.connect(onGrabMaterial)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if boundPlayer != null and not launching and not retracting:
		if orientation == Cardinals.RIGHT:
			if boundPlayer.isInputJustPressed(boundPlayer.rightInput):
				launch()
			elif boundPlayer.isInputJustPressed(boundPlayer.leftInput):
				unbindPlayer()
			else:
				if boundPlayer.isInputPressed(boundPlayer.upInput):
					rotation -= rotationSpeed*delta
				if boundPlayer.isInputPressed(boundPlayer.downInput):
					rotation += rotationSpeed*delta
		elif orientation == Cardinals.LEFT:
			if boundPlayer.isInputJustPressed(boundPlayer.leftInput):
				launch()
			elif boundPlayer.isInputJustPressed(boundPlayer.rightInput):
				unbindPlayer()
			else:
				if boundPlayer.isInputPressed(boundPlayer.downInput):
					rotation -= rotationSpeed*delta
				if boundPlayer.isInputPressed(boundPlayer.upInput):
					rotation += rotationSpeed*delta

	rotation = clampf(rotation, baseRotation-additionalRotation, baseRotation+additionalRotation)

	if launching:
		position += Vector2.from_angle(rotation) * launchSpeed * delta
		# trail.add_point(global_position)
		timeSinceLaunch += delta
		if timeSinceLaunch >= launchTime:
			retract()
	
	elif retracting:

		position -= Vector2.from_angle(rotation) * retractSpeed * delta
		# while (global_position - launchPoint).length() < (trail.get_point_position(-1)-launchPoint).length():
		# 	trail.remove_point(-1)
		timeSinceLaunch += delta
		if (global_position - launchPoint).length() <= retractSpeed * delta:
			retracting = false
			global_position = launchPoint
			trail.clear_points()
			if retrievedMaterial != PlayerUI.Carriable.NONE:
				grabbedMaterialSprite.hide()
				unbindPlayer()

func bindPlayer(player: Player):
	boundPlayer = player

func unbindPlayer():
	boundPlayer = null
	onPlayerUnbind.emit(retrievedMaterial)
	retrievedMaterial = PlayerUI.Carriable.NONE

func launch():
	launching = true
	timeSinceLaunch = 0
	sprite.region_rect.position = Vector2(32,32)

func retract():
	launching = false
	retracting = true
	sprite.region_rect.position = Vector2(0,32)

func onGrabMaterial(grabbedMaterial: Area2D):

	if not launching and not retracting: return

	if grabbedMaterial is RealTree:
		(grabbedMaterial as RealTree).chop()
		grabbedMaterialSprite.show()
		grabbedMaterialSprite.region_rect.position = Vector2.ZERO
		retrievedMaterial = PlayerUI.Carriable.WOOD
	elif grabbedMaterial is Truck:
		grabbedMaterial.collect()
		grabbedMaterialSprite.show()
		grabbedMaterialSprite.region_rect.position = Vector2(12,0)
		retrievedMaterial = PlayerUI.Carriable.METAL

	retract()
