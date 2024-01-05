extends Node3D

@export var isInitialLoop: bool = false
@export var nextLoop: PackedScene

func _ready():
	MainCharacter.trackInput = true
	if isInitialLoop:
		MainCharacter.show()
		MainCharacter.global_position = $StartingPos.global_position
		MainCharacter.rotation.y = deg_to_rad(180)
		Transition.doTransition(Transition.Type.FADE, true, 2, true)
		await Transition.transitionFinished
