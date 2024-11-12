class_name AmmoProcessor
extends LockingInteractionZone

@export var processedAmmoSprites: Array[Sprite2D]
var processingMaterial: PlayerUI.Carriable
var processedAmmoTypes: Array[PlayerUI.Carriable]

var processedAmmo: int:
	set(value):
		processedAmmo = value
		for i in range(4):
			if i < processedAmmo:
				processedAmmoSprites[i].show()
				if processedAmmoTypes[i] == PlayerUI.Carriable.WOODEN_BULLETS:
					processedAmmoSprites[i].region_rect.position = Vector2(0,24)
				elif processedAmmoTypes[i] == PlayerUI.Carriable.METAL_BULLETS:
					processedAmmoSprites[i].region_rect.position = Vector2(12,12)
			else: processedAmmoSprites[i].hide()

func _ready():
	super()
	processedAmmo = 0
	for processedAmmoSprite in processedAmmoSprites:
		processedAmmoTypes.append(PlayerUI.Carriable.NONE)

func canPlayerBeLocked(playerUI: PlayerUI):
	return (
		lockedPlayer == null and playerUI.readyToLock and (
			playerUI.carriedMaterial == PlayerUI.Carriable.WOOD or
			playerUI.carriedMaterial == PlayerUI.Carriable.METAL
		) and processedAmmo <= 3
	)


func lockPlayer(playerUI: PlayerUI):
	playerUI.lockMovement(global_position)
	processingMaterial = playerUI.carriedMaterial
	playerUI.carriedMaterial = PlayerUI.Carriable.NONE
	lockedPlayer = playerUI
	playerUI.onCompletedArrows.connect(unlockPlayer)
	playerUI.resetArrows()

func unlockPlayer():
	if processingMaterial == PlayerUI.Carriable.WOOD:
		processedAmmoTypes[processedAmmo] = PlayerUI.Carriable.WOODEN_BULLETS
	elif processingMaterial == PlayerUI.Carriable.METAL:
		processedAmmoTypes[processedAmmo] = PlayerUI.Carriable.METAL_BULLETS
	lockedPlayer.carriedMaterial = processedAmmoTypes[processedAmmo]
	processedAmmo += 1
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
	elif playerUI.carriedMaterial == playerUI.Carriable.NONE and processedAmmo > 0:
		processedAmmo -= 1
		playerUI.carriedMaterial = processedAmmoTypes[processedAmmo]
		

func onPlayerExited(playerUI: Node2D):
	playerUI.readyToLock = true
	currentPlayers.erase(playerUI)
