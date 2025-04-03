extends Node

enum PlayerName {
	APPEND, EVAL, RANGE, JOIN, MIN, MAX, UPPER, LOWER,
	SPLIT, STRIP, LEN, DICT, LIST, PRINT, INPUT, OPEN,
}

const playerColors: Dictionary = {
	PlayerName.APPEND : Color.CRIMSON,
	PlayerName.EVAL : Color.ORANGE,
	PlayerName.RANGE : Color.YELLOW,
	PlayerName.JOIN : Color.FOREST_GREEN,
	PlayerName.MIN : Color.CYAN,
	PlayerName.MAX : Color.PURPLE,
	PlayerName.UPPER : Color.HOT_PINK,
	PlayerName.LOWER : Color.SADDLE_BROWN,
	PlayerName.SPLIT : Color.DARK_GRAY,
	PlayerName.STRIP : Color.BLUE,
	PlayerName.LEN : Color.LIME_GREEN,
	PlayerName.DICT : Color.WHITE,
	PlayerName.LIST : Color.GREEN_YELLOW,
	PlayerName.PRINT : Color.DARK_SLATE_GRAY,
	PlayerName.INPUT : Color.DARK_GOLDENROD,
	PlayerName.OPEN : Color.TOMATO,
}

func getPlayerSpriteRegion(playerName: PlayerName) -> Vector2:
	match playerName:
		PlayerName.APPEND:
			return Vector2(0,0)
		PlayerName.EVAL:
			return Vector2(48,0)
		PlayerName.RANGE:
			return Vector2(96,0)
		PlayerName.JOIN:
			return Vector2(144,0)
		PlayerName.MIN:
			return Vector2(0,48)
		PlayerName.MAX:
			return Vector2(48,48)
		PlayerName.UPPER:
			return Vector2(96,48)
		PlayerName.LOWER:
			return Vector2(144,48)
		PlayerName.SPLIT:
			return Vector2(0,96)
		PlayerName.STRIP:
			return Vector2(48,96)
		PlayerName.LEN:
			return Vector2(96,96)
		PlayerName.DICT:
			return Vector2(144,96)
		PlayerName.LIST:
			return Vector2(0,144)
		PlayerName.PRINT:
			return Vector2(48,144)
		PlayerName.INPUT:
			return Vector2(96,144)
		PlayerName.OPEN:
			return Vector2(144,144)
		_: return Vector2.ZERO


var isIconActive: Dictionary
var playersByInputSet: Dictionary
func isInputSetActive(inputSet: InputSets.InputSet):
	if inputSet not in playersByInputSet: return false
	else: return isIconActive[playersByInputSet[inputSet].name]
func getActivePlayers():
	var activePlayers: Array[Player]
	for inputSet in playersByInputSet:
		if isIconActive[playersByInputSet[inputSet].name]:
			activePlayers.append(playersByInputSet[inputSet])
	return activePlayers


func _ready():
	# print(Input.get_connected_joypads())
	# var multiplayerInputs: Array[DeviceInput] = []
	# for input in Input.get_connected_joypads():
	# 	multiplayerInputs.append(DeviceInput.new(input))
	# for input in multiplayerInputs:
	# 	print(input.get_name())
	for playerName in PlayerName.values():
		isIconActive[playerName] = false
	# initTestPlayers()

func _process(_delta):
	pass
	# print(Input.get_connected_joypads())

func getInactivePlayerIcon(inactivateMe = null, autoActivate = true, startIndex = 0, step = 1) -> PlayerName:
	var iconToReturn: PlayerName
	while isIconActive[PlayerName.values()[startIndex]]:
		startIndex = wrapi(startIndex+step, 0, len(PlayerName))
	iconToReturn = PlayerName.values()[startIndex]
	if inactivateMe != null: isIconActive[inactivateMe] = false
	if autoActivate: isIconActive[iconToReturn] = true
	return iconToReturn


# Really just for testing.
func forceAddPlayer(inputSet: InputSets.InputSet, playerName: PlayerName, sdInput = 0):
	var newPlayer := Player.new(inputSet, playerName)
	newPlayer.addSDInput(sdInput)
	playersByInputSet[inputSet] = newPlayer
	isIconActive[playerName] = true
	newPlayer.active = true

func getNewPlayer(inputSet: InputSets.InputSet) -> Player:
	var playerName = getInactivePlayerIcon()
	var newPlayer := Player.new(inputSet, playerName)
	playersByInputSet[inputSet] = newPlayer
	return newPlayer

func getPlayerForInputSet(inputSet: InputSets.InputSet) -> Player:
	var player: Player
	if inputSet in playersByInputSet:
		player = playersByInputSet[inputSet]
		if isIconActive[player.name]: player.name = getInactivePlayerIcon()
		else: isIconActive[player.name] = true
	else:
		player = getNewPlayer(inputSet)
	player.active = true
	return player

func deactivatePlayer(player: Player):
	isIconActive[player.name] = false
	player.active = false

func clearPlayers():
	for inputSet in playersByInputSet:
		inputSet.unassignPlayer()
		isIconActive[playersByInputSet[inputSet].name] = false
	playersByInputSet.clear()


func initTestPlayers():
	# forceAddPlayer(InputSets.inputSets[0], PlayerName.LIST, KEY_ENTER)
	# forceAddPlayer(InputSets.inputSets[1], getInactivePlayerIcon(), KEY_ENTER)
	for i in range(16):
		forceAddPlayer(InputSets.inputSets[i], getInactivePlayerIcon())
	pass
