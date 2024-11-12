class_name InteractionZone
extends Area2D

var currentPlayers: Array[PlayerUI]

func _ready():
	body_entered.connect(onPlayerEntered)
	body_exited.connect(onPlayerExited)

func onPlayerEntered(playerUI: Node2D):
	currentPlayers.append(playerUI)

func onPlayerExited(playerUI: Node2D):
	currentPlayers.erase(playerUI)