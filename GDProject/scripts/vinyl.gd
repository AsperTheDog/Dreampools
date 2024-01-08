extends Area3D

@export var audioPlayer: AudioStreamPlayer3D


func interact():
	if audioPlayer.playing:
		audioPlayer.stop()
		$vinyl.play()
	else:
		$vinyl.play()
		await $vinyl.finished
		audioPlayer.play()
