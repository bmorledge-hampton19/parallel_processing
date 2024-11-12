class_name LockingInteractionZone
extends InteractionZone

var lockedPlayer: PlayerUI

func _ready():
	super()

func canPlayerBeLocked(playerUI: PlayerUI):
	if lockedPlayer != null: return false
	else: return playerUI.readyToLock

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
