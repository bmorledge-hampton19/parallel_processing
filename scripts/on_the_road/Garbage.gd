class_name Garbage
extends InteractionZone

func onPlayerEntered(playerUI: Node2D):
	currentPlayers.append(playerUI)
	playerUI.carriedMaterial = PlayerUI.Carriable.NONE


func onPlayerExited(playerUI: Node2D):
	currentPlayers.erase(playerUI)

func _ready():
	body_entered.connect(onPlayerEntered)
	body_exited.connect(onPlayerExited)