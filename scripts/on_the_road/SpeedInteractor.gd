class_name SpeedInteractor
extends LockingInteractionZone

signal onFuelConsumptionChange(consumptionChange: int)

func _ready():
	super()

func _process(delta):
	if lockedPlayer != null:
		if lockedPlayer.player.isInputJustPressed(lockedPlayer.player.downInput):
			unlockPlayer()
		elif lockedPlayer.player.isInputJustPressed(lockedPlayer.player.leftInput):
			onFuelConsumptionChange.emit(-1)
		elif lockedPlayer.player.isInputJustPressed(lockedPlayer.player.rightInput):
			onFuelConsumptionChange.emit(1)
		

func canPlayerBeLocked(playerUI: PlayerUI):
	return lockedPlayer == null and playerUI.readyToLock


func lockPlayer(playerUI: PlayerUI):
	playerUI.lockMovement(global_position)
	lockedPlayer = playerUI

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
