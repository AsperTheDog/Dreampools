extends Control


var paused: bool = false:
	set(value):
		if paused == value: return
		paused = value
		if paused:
			MainCharacter.trackInput = false
			Engine.time_scale = 0
		elif MainCharacter.visible:
			MainCharacter.trackInput = true
			Engine.time_scale = 1
		visible = paused

var busy: bool = false:
	set(value):
		if busy == value: return
		busy = value
		visible = not busy


func _on_continue_pressed():
	paused = false
	MainCharacter.trackInput = true


func _on_options_pressed():
	busy = true
	Options.show()
	await Options.changedVisibility
	busy = false


func _on_exit_pressed():
	paused = false
	get_tree().change_scene_to_file("res://scenes/levels/mainMenu.tscn")
