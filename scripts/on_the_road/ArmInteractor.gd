class_name ArmInteractor
extends LockingInteractionZone

@export var arm: Arm

func _ready():
	super()
	arm.onPlayerUnbind.connect(unlockAndGiveMaterial)

func canPlayerBeLocked(playerUI: PlayerUI):
	if lockedPlayer != null: return false
	else: return (playerUI.readyToLock and playerUI.carriedMaterial == playerUI.Carriable.NONE)

func lockPlayer(playerUI: PlayerUI):
	playerUI.lockMovement(global_position)
	lockedPlayer = playerUI
	arm.bindPlayer(playerUI.player)

func unlockAndGiveMaterial(retrievedMaterial: PlayerUI.Carriable):
	lockedPlayer.carriedMaterial = retrievedMaterial
	unlockPlayer()

func unlockPlayer():
	lockedPlayer.unlockMovement()
	lockedPlayer = null
	for currentPlayer in currentPlayers:
		if canPlayerBeLocked(currentPlayer):
			lockPlayer(currentPlayer)
			break

func onPlayerEntered(playerUI: Node2D):
	currentPlayers.append(playerUI)
	if canPlayerBeLocked(playerUI): lockPlayer(playerUI)

func onPlayerExited(playerUI: Node2D):
	playerUI.readyToLock = true
	currentPlayers.erase(playerUI)
