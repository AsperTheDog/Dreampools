extends Node3D

@export var song: AudioStream

func _ready():
	$AudioStreamPlayer3D.stream = song
	$AudioStreamPlayer3D.play()
