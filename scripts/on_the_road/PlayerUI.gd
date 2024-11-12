class_name PlayerUI
extends RigidBody2D

enum Carriable {
	NONE, WOOD, METAL,
	FUEL,
	WOODEN_BULLETS, METAL_BULLETS
}

enum {UP, RIGHT, LEFT, DOWN}

@export var playerColorRect: ColorRect
@export var playerIcon: Sprite2D
@export var playerName: Label

@export var carriedMaterialSprite: Sprite2D
@export var ammoType: TextureRect
@export var ammoCount: Label

@export var arrowsContainer: Node2D
@export var arrows: Array[Sprite2D]

var player: Player
var speed := 100.0
var direction := Vector2.ZERO
var _movementLocked: bool
var forcedPosition: Vector2
var readyToLock: bool = true
var carriedMaterial: Carriable:
	set(value):
		carriedMaterial = value
		match carriedMaterial:
			Carriable.NONE:
				carriedMaterialSprite.hide()
			Carriable.WOOD:
				carriedMaterialSprite.show()
				carriedMaterialSprite.region_rect.position = Vector2(0,0)
			Carriable.METAL:
				carriedMaterialSprite.show()
				carriedMaterialSprite.region_rect.position = Vector2(12,0)
			Carriable.FUEL:
				carriedMaterialSprite.show()
				carriedMaterialSprite.region_rect.position = Vector2(0,12)
			Carriable.WOODEN_BULLETS:
				carriedMaterialSprite.show()
				carriedMaterialSprite.region_rect.position = Vector2(0,24)
			Carriable.METAL_BULLETS:
				carriedMaterialSprite.show()
				carriedMaterialSprite.region_rect.position = Vector2(12,12)
	get:
		return carriedMaterial
var carryingBullets: bool:
	get:
		return (
			carriedMaterial == Carriable.WOODEN_BULLETS or
			carriedMaterial == Carriable.METAL_BULLETS
		)

signal onCompletedArrows()
var activeArrows: bool
var incorrectInputs: bool
var incorrectInputsTimer: float
var arrowOrientations: Array[int] = [0,0,0,0]
var correctInputs: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func instantiate(p_player: Player):
	player = p_player
	playerColorRect.color = player.color
	playerName.text = str(PlayerManager.PlayerName.keys()[player.name]).capitalize()
	playerIcon.region_rect.position = PlayerManager.getPlayerSpriteRegion(player.name)

func _physics_process(_delta):
	if _movementLocked:
		return
	direction = Vector2.ZERO
	if player.isInputPressed(player.upInput): direction += Vector2.UP
	if player.isInputPressed(player.rightInput): direction += Vector2.RIGHT
	if player.isInputPressed(player.downInput): direction += Vector2.DOWN
	if player.isInputPressed(player.leftInput): direction += Vector2.LEFT
	direction = direction.normalized()
	linear_velocity = direction*speed

func _integrate_forces(state):
	if _movementLocked and global_position != forcedPosition:
		global_position = forcedPosition

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if activeArrows and not incorrectInputs:
		var justPressedInputs := player.inputSet.getJustPressedInputs()
		while justPressedInputs:

			var nextExpectedInput: String
			if arrowOrientations[correctInputs] == UP:
				nextExpectedInput = player.upInput
			if arrowOrientations[correctInputs] == RIGHT:
				nextExpectedInput = player.rightInput
			if arrowOrientations[correctInputs] == DOWN:
				nextExpectedInput = player.downInput
			if arrowOrientations[correctInputs] == LEFT:
				nextExpectedInput = player.leftInput
			
			if nextExpectedInput in justPressedInputs:
				arrows[correctInputs].modulate = Color.GREEN
				correctInputs += 1
				justPressedInputs.erase(nextExpectedInput)
			else:
				for arrow in arrows: arrow.modulate = Color.RED
				incorrectInputs = true
				incorrectInputsTimer = 1
				break
			
			if correctInputs == 4:
				onCompletedArrows.emit()
				activeArrows = false
				arrowsContainer.hide()
				break

	if incorrectInputs:
		incorrectInputsTimer -= delta
		if incorrectInputsTimer <= 0: resetArrows()

func lockMovement(new_global_position: Vector2):
	_movementLocked = true
	linear_velocity = Vector2.ZERO
	forcedPosition = new_global_position
	readyToLock = false

func unlockMovement():
	_movementLocked = false

func setArrow(arrowIndex: int, orientation: int):
	if orientation == UP:
		arrows[arrowIndex].region_rect.position = Vector2(16,16)
	elif orientation == RIGHT:
		arrows[arrowIndex].region_rect.position = Vector2(0,16)
	elif orientation == DOWN:
		arrows[arrowIndex].region_rect.position = Vector2(16,0)
	elif orientation == LEFT:
		arrows[arrowIndex].region_rect.position = Vector2(0,0)
	arrowOrientations[arrowIndex] = orientation
	arrows[arrowIndex].modulate = Color.WHITE


func resetArrows():
	activeArrows = true
	incorrectInputs = false
	correctInputs = 0
	arrowsContainer.show()
	for i in len(arrows):
		setArrow(i, randi_range(0,3))
