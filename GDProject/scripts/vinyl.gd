extends Area3D

@export var audioPlayer: AudioStreamPlayer3D


func interact():
	if audioPlayer.playing:
		audioPlayer.stop()
		$vinyl.play()
		triggerDialogue()
	else:
		$vinyl.play()
		await $vinyl.finished
		audioPlayer.play()


static var triggered: bool = false
func triggerDialogue():
	if triggered: return
	triggered = true
	Subtitles.startSubtitle("loop3-father5")
