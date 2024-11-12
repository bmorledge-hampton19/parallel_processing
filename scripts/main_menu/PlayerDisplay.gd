class_name PlayerDisplay
extends Node

@export var playerColorRect: ColorRect
@export var playerName: Label
@export var playerSprite: Sprite2D

@export var controllerIconTextureRect: TextureRect
@export var controllerNumLabel: Label
@export var keyboardIconTextureRect: TextureRect

@export var faceButtonsTextureRect: TextureRect
@export var dpadTextureRect: TextureRect
@export var leftStickTextureRect: TextureRect
@export var rightStickTextureRect: TextureRect

@export var keysControl: Control
@export var upKeyTextureRect: TextureRect
@export var rightKeyTextureRect: TextureRect
@export var downKeyTextureRect: TextureRect
@export var leftKeyTextureRect: TextureRect
const controllerPromptsDir = "res://images/controller_prompts/"
const wKey = controllerPromptsDir + "W_Key_Dark.png"
const dKey = controllerPromptsDir + "D_Key_Dark.png"
const sKey = controllerPromptsDir + "S_Key_Dark.png"
const aKey = controllerPromptsDir + "A_Key_Dark.png"
const iKey = controllerPromptsDir + "I_Key_Dark.png"
const lKey = controllerPromptsDir + "L_Key_Dark.png"
const kKey = controllerPromptsDir + "K_Key_Dark.png"
const jKey = controllerPromptsDir + "J_Key_Dark.png"
const upArrowKey = controllerPromptsDir + "Arrow_Up_Key_Dark.png"
const rightArrowKey = controllerPromptsDir + "Arrow_Right_Key_Dark.png"
const downArrowKey = controllerPromptsDir + "Arrow_Down_Key_Dark.png"
const leftArrowKey = controllerPromptsDir + "Arrow_Left_Key_Dark.png"
const eightKey = controllerPromptsDir + "8_Key_Dark.png"
const sixKey = controllerPromptsDir + "6_Key_Dark.png"
const fiveKey = controllerPromptsDir + "5_Key_Dark.png"
const fourKey = controllerPromptsDir + "4_Key_Dark.png"

@export var closeButton: TextureButton

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initPlayerDisplay(p_player: Player):
	player = p_player

	playerColorRect.color = player.color
	playerName.text = str(PlayerManager.PlayerName.keys()[player.name]).capitalize()
	playerSprite.region_rect.position = PlayerManager.getPlayerSpriteRegion(player.name)

	if player.inputSet.device == -1:
		keyboardIconTextureRect.show()
		keysControl.show()
		match player.inputSet.name:
			InputSets.WASD:
				upKeyTextureRect.texture = preload(wKey)
				rightKeyTextureRect.texture = preload(dKey)
				downKeyTextureRect.texture = preload(sKey)
				leftKeyTextureRect.texture = preload(aKey)
			InputSets.IJKL:
				upKeyTextureRect.texture = preload(iKey)
				rightKeyTextureRect.texture = preload(lKey)
				downKeyTextureRect.texture = preload(kKey)
				leftKeyTextureRect.texture = preload(jKey)
			InputSets.ARROW_KEYS:
				upKeyTextureRect.texture = preload(upArrowKey)
				rightKeyTextureRect.texture = preload(rightArrowKey)
				downKeyTextureRect.texture = preload(downArrowKey)
				leftKeyTextureRect.texture = preload(leftArrowKey)
			InputSets.NUMPAD:
				upKeyTextureRect.texture = preload(eightKey)
				rightKeyTextureRect.texture = preload(sixKey)
				downKeyTextureRect.texture = preload(fiveKey)
				leftKeyTextureRect.texture = preload(fourKey)
	else:
		controllerIconTextureRect.show()
		controllerNumLabel.show()
		controllerNumLabel.text = str(player.inputSet.device+1)
		match player.inputSet.name:
			InputSets.FACE_BUTTONS: faceButtonsTextureRect.show()
			InputSets.DPAD: dpadTextureRect.show()
			InputSets.LEFT_JOYSTICK: leftStickTextureRect.show()
			InputSets.RIGHT_JOYSTICK: rightStickTextureRect.show()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var isPlayerChanged = false
	if player.isInputJustPressed(player.leftInput) or player.isInputJustPressed(player.downInput):
		player.name = PlayerManager.getInactivePlayerIcon(player.name, true, player.name, -1)
		isPlayerChanged = true
	if player.isInputJustPressed(player.rightInput) or player.isInputJustPressed(player.upInput):
		player.name = PlayerManager.getInactivePlayerIcon(player.name, true, player.name, 1)
		isPlayerChanged = true
		


	if isPlayerChanged:
		playerColorRect.color = player.color
		playerName.text = str(PlayerManager.PlayerName.keys()[player.name]).capitalize()
		playerSprite.region_rect.position = PlayerManager.getPlayerSpriteRegion(player.name)
