class_name WoodProcessor
extends LockingInteractionZone

@export var processedFuelSprites: Array[Sprite2D]

@export var audioOnChop: AudioStreamPlayer2D

var processedFuel: int:
	set(value):
		processedFuel = value
		for i in range(4):
			if i < processedFuel: processedFuelSprites[i].show()
			else: processedFuelSprites[i].hide()

func _ready():
	super()
	processedFuel = 0

func canPlayerBeLocked(playerUI: PlayerUI):
	return (
		lockedPlayer == null and playerUI.readyToLock and
		playerUI.carriedMaterial == PlayerUI.Carriable.WOOD and processedFuel <= 3
	)


func lockPlayer(playerUI: PlayerUI):
	playerUI.lockMovement(global_position)
	playerUI.carriedMaterial = PlayerUI.Carriable.NONE
	lockedPlayer = playerUI
	playerUI.onCompletedArrows.connect(unlockPlayer)
	playerUI.resetArrows()

func unlockPlayer():
	audioOnChop.play()
	processedFuel += 1
	lockedPlayer.carriedMaterial = PlayerUI.Carriable.FUEL
	lockedPlayer.unlockMovement()
	lockedPlayer.onCompletedArrows.disconnect(unlockPlayer)
	lockedPlayer = null
	for currentPlayer in currentPlayers:
		if canPlayerBeLocked(currentPlayer):
			lockPlayer(currentPlayer)
			break

func onPlayerEntered(playerUI: Node2D):
	currentPlayers.append(playerUI)
	if canPlayerBeLocked(playerUI): lockPlayer(playerUI)
	elif playerUI.carriedMaterial == playerUI.Carriable.NONE and processedFuel > 0:
		playerUI.carriedMaterial = playerUI.Carriable.FUEL
		processedFuel -= 1
		

func onPlayerExited(playerUI: Node2D):
	playerUI.readyToLock = true
	currentPlayers.erase(playerUI)
