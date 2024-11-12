class_name GunInteractor
extends LockingInteractionZone

@export var gun: Gun

func _ready():
	super()
	gun.onPlayerUnbind.connect(unlockPlayer)

func canPlayerBeLocked(playerUI: PlayerUI):
	if lockedPlayer != null: return false
	else: return playerUI.readyToLock and playerUI.carriedMaterial == playerUI.Carriable.NONE

func lockPlayer(playerUI: PlayerUI):
	playerUI.lockMovement(global_position)
	lockedPlayer = playerUI
	gun.bindPlayer(playerUI.player)

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
	if playerUI.carryingBullets: addBullets(playerUI)
	if canPlayerBeLocked(playerUI):
		lockPlayer(playerUI)

func onPlayerExited(playerUI: Node2D):
	playerUI.readyToLock = true
	currentPlayers.erase(playerUI)

func addBullets(playerUI: PlayerUI):
	if playerUI.carriedMaterial == PlayerUI.Carriable.WOODEN_BULLETS:
		gun.woodenAmmo += 25
	elif playerUI.carriedMaterial == PlayerUI.Carriable.METAL_BULLETS:
		gun.metalAmmo += 25
	playerUI.carriedMaterial = PlayerUI.Carriable.NONE
