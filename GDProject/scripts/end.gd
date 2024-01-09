extends Control


func end():
	$AnimationPlayer.play("thanks")
	await get_tree().create_timer(9).timeout
	get_tree().change_scene_to_file("res://scenes/levels/mainMenu.tscn")
