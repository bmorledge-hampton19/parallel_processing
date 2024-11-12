class_name FuelProcessor
extends InteractionZone

signal onRefuel()

func onPlayerEntered(playerUI: Node2D):
	currentPlayers.append(playerUI)
	var intermediate = playerUI.carriedMaterial
	if playerUI.carriedMaterial == PlayerUI.Carriable.FUEL:
		playerUI.carriedMaterial = PlayerUI.Carriable.NONE
		onRefuel.emit()


func onPlayerExited(playerUI: Node2D):
	currentPlayers.erase(playerUI)

func _ready():
	body_entered.connect(onPlayerEntered)
	body_exited.connect(onPlayerExited)