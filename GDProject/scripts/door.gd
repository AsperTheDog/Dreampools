extends Area3D

@export var door: Node3D
@export var white: Node3D
@export var music: Node3D

var interacted: bool = false


func interact():
	if interacted: return
	interacted = true
	white.show()
	music.finish()
	door.get_node("AnimationPlayer").play("open-door")
	$sound2.play()
	await get_tree().create_timer(1.0333).timeout
	get_tree().current_scene.tpToFinalLoop()
	$sound.play()
	await get_tree().create_timer(0.5).timeout
	$sound3.play()
