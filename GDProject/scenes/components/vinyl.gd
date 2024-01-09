extends Node3D

@export var initialSong: AudioStream
@export var song: AudioStream

func _ready():
	if initialSong != null:
		$AudioStreamPlayer3D.stream = initialSong
		$AudioStreamPlayer3D.play()
		await $AudioStreamPlayer3D.finished
	$AudioStreamPlayer3D.stream = song
	$AudioStreamPlayer3D.play()
