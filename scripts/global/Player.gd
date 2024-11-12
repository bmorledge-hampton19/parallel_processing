class_name Player
extends Object

var color: Color:
	get:
		return PlayerManager.playerColors[name]
var active: bool
var inputSet: InputSets.InputSet
var leftInput: String:
	get: return inputSet.leftInput
var rightInput: String:
	get: return inputSet.rightInput
var upInput: String:
	get: return inputSet.upInput
var downInput: String:
	get: return inputSet.downInput
var sdInput: int
var name: PlayerManager.PlayerName

func _init(p_inputSet: InputSets.InputSet, p_name: PlayerManager.PlayerName):
	inputSet = p_inputSet
	inputSet.assignPlayer(self)
	name = p_name

func addSDInput(p_sdInput):
	sdInput = p_sdInput

func isInputPressed(input: String) -> bool:
	if input: return inputSet.inputPressed[input]
	else: return false

func isInputJustPressed(input: String) -> bool:
	if input: return inputSet.inputJustPressed[input]
	else: return false
