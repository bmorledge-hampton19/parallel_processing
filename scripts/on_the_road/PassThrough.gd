extends InteractionZone

@export var materialSprite: Sprite2D

var storedMaterial: PlayerUI.Carriable:
	set(value):
		storedMaterial = value
		match storedMaterial:
			PlayerUI.Carriable.NONE:
				materialSprite.hide()
			PlayerUI.Carriable.WOOD:
				materialSprite.show()
				materialSprite.region_rect.position = Vector2(0,0)
			PlayerUI.Carriable.METAL:
				materialSprite.show()
				materialSprite.region_rect.position = Vector2(12,0)
			PlayerUI.Carriable.FUEL:
				materialSprite.show()
				materialSprite.region_rect.position = Vector2(0,12)
			PlayerUI.Carriable.WOODEN_BULLETS:
				materialSprite.show()
				materialSprite.region_rect.position = Vector2(0,24)
			PlayerUI.Carriable.METAL_BULLETS:
				materialSprite.show()
				materialSprite.region_rect.position = Vector2(12,12)

func onPlayerEntered(playerUI: Node2D):
	currentPlayers.append(playerUI)
	var intermediate = playerUI.carriedMaterial
	playerUI.carriedMaterial = storedMaterial
	storedMaterial = intermediate


func onPlayerExited(playerUI: Node2D):
	currentPlayers.erase(playerUI)

func _ready():
	body_entered.connect(onPlayerEntered)
	body_exited.connect(onPlayerExited)
