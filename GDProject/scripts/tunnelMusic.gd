extends Node3D

var done: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not done:
		var dist := inverse_lerp($begin.global_position.z, $end.global_position.z, MainCharacter.global_position.z)
		$music.volume_db = linear_to_db(dist)


func finish():
	var dist := inverse_lerp($begin.global_position.z, $end.global_position.z, MainCharacter.global_position.z)
	create_tween().tween_method(func(value): $music.volume_db = linear_to_db(value), dist, 0, 0.2)
	done = true
