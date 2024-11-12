extends Node

@export var playerSprites: Array[Sprite2D]
@export var finalMessage: Label

var players: int

func _ready():
	var playerName: PlayerManager.PlayerName
	for i in range(16):
		playerName = PlayerManager.PlayerName.values()[i]
		if PlayerManager.isIconActive[playerName]:
			playerSprites[i].region_rect.position = PlayerManager.getPlayerSpriteRegion(playerName)
			players += 1
		else:
			playerSprites[i].hide()
	
	if players == 1:
		finalMessage.text = (
			"\"My... child!?\n" +
			"Where are your siblings?\n" +
			"How on earth did you get here alone!\""
		)
	elif players <= 4:
		finalMessage.text = (
			"\"My children!\n" +
			"You are very brave to come with so few\n" +
			"of you. Your courage will be remembered!\""
		)
	elif players <= 8:
		finalMessage.text = (
			"\"My children!\n" +
			"I had hoped to see more of your siblings,\n" +
			"but I am glad indeed that you have come for me.\""
		)
	elif players < 16:
		finalMessage.text = (
			"\"My children!\n" +
			"So many of you have come to my aid!\n" +
			"It is wonderful to see you.\""
		)
	elif players == 16:
		finalMessage.text = (
			"\"My children!\n" +
			"ALL of you have come to rescue me?\n" +
			"This will be a joyous family reunion!\""
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("PRIMARY_MENU_BUTTON"):
		SceneManager.transitionToScene(SceneManager.Scene.MAIN_MENU)
