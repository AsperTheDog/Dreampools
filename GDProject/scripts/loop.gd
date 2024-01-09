extends Node3D

@export var isInitialLoop: bool = false
@export var nextLoop: PackedScene
@export var nextArea: Area3D
@export var flipSubtitles: bool = false

var shouldJumpToNext: bool = false

func _ready():
	Subtitles.upsideDown = flipSubtitles
	MainCharacter.trackInput = true
	if isInitialLoop:
		MainCharacter.show()
		MainCharacter.global_position = $StartingPos.global_position
		MainCharacter.rotation.y = deg_to_rad(180)
		MainCharacter.standUp()
		Transition.doTransition(Transition.Type.FADE, true, 2, true)
		await Transition.transitionFinished
	if nextArea != null:
		nextArea.body_entered.connect(func(_body): shouldJumpToNext = true)


var jumped: bool = false
func _process(_delta):
	if shouldJumpToNext and not jumped:
		jumped = true
		get_tree().change_scene_to_packed(nextLoop)


func playSubtitle(subtitle: String):
	Subtitles.startSubtitle(subtitle)


func tpToFinalLoop():
	Transition.doTransition(Transition.Type.WHITE_FADE, false, 3, true)
	await Transition.transitionFinished
	get_tree().change_scene_to_file("res://scenes/levels/loop8.tscn")


func endGame():
	MainCharacter.endGame()
	Transition.doTransition(Transition.Type.FADE, false, 3, true)
	await Transition.transitionFinished
	Transition.end()
