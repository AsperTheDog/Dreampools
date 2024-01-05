extends Node3D


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Transition.doTransition(Transition.Type.FADE, true, 3, true)


func _process(delta: float):
	if Input.is_action_just_pressed("pause") and Options.visible:
		Options.hide()


func _on_start():
	$Control.hide()
	Transition.doTransition(Transition.Type.FADE, false, 2)
	await Transition.transitionFinished
	get_tree().change_scene_to_file("res://scenes/levels/loop1.tscn")


func _on_options():
	$Control.hide()
	Options.show()
	await Options.changedVisibility
	$Control.show()


func _on_exit():
	get_tree().quit()
