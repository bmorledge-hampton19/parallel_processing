class_name MainMenu
extends Node

@export var playerSelectorPrefab: PackedScene
@export var playerSelectorGrid: GridContainer

@export var playButton: PlayButton

@export var storyButton: Button
@export var tutorialButton: Button

var playerSelectors: Array[PlayerSelector]

func attemptAddPlayer(inputSet: InputSets.InputSet, _direction):
	if inputSet.assignedPlayer != null and inputSet.assignedPlayer.active: return
	if playerSelectors[-1].player != null: return
	playerSelectors[-1].transitionToPlayerDisplay(inputSet)

	if len(playerSelectors) < 16: addPlayerSelector()

func forceAddPlayer(inputSet: InputSets.InputSet):
	playerSelectors[-1].transitionToPlayerDisplay(inputSet, true)

	if len(playerSelectors) < 16: addPlayerSelector()


func addPlayerSelector():
	var playerSelector := playerSelectorPrefab.instantiate()
	playerSelectorGrid.add_child(playerSelector)
	playerSelectors.append(playerSelector)
	playerSelector.playerDisplay.closeButton.pressed.connect(func(): removePlayerSelector(playerSelector))

func removePlayerSelector(playerSelector: PlayerSelector):
	playerSelectors.erase(playerSelector)
	PlayerManager.deactivatePlayer(playerSelector.player)
	playerSelector.queue_free()
	if playerSelectors[-1].player != null: addPlayerSelector()

func startGame():
	# get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(mainScene.resource_path))
	SceneManager.transitionToScene(SceneManager.Scene.MAIN_SCENE)

# Called when the node enters the scene tree for the first time.
func _ready():
	addPlayerSelector()
	for inputSet in PlayerManager.playersByInputSet:
		if PlayerManager.isInputSetActive(inputSet): forceAddPlayer(inputSet)
	InputSets.onAnyCircle.connect(attemptAddPlayer)
	playButton.onFullProgressCircle.connect(startGame)
	# ResourceLoader.load_threaded_request(mainScene.resource_path)

	storyButton.pressed.connect(func(): SceneManager.transitionToScene(SceneManager.Scene.STORY))
	tutorialButton.pressed.connect(func(): SceneManager.transitionToScene(SceneManager.Scene.TUTORIAL))
