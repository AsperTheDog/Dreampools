extends Node3D

@export var isInitialLoop: bool = false
@export var nextLoop: PackedScene
@export var nextArea: Area3D

var shouldJumpToNext: bool = false

func _ready():
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


var playedSubtitles: Array[String] = []
func playSubtitle(subtitle: String, force: bool = false):
	if not subtitle in playedSubtitles: playedSubtitles.append(subtitle)
	elif not force: return
	Subtitles.startSubtitle(subtitle)
