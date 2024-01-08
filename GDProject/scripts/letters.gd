extends Control

var data: Dictionary = preload("res://assets/letters.json").data

var firstLetterShown: bool = false


func _ready():
	hide()


func _process(delta):
	if visible and Input.is_action_just_pressed("pause"):
		hide()
		MainCharacter.trackInput = true
		if not firstLetterShown:
			firstLetterShown = true
			get_tree().current_scene.playSubtitle("loop4-father4")


func showLetter(letter: String):
	$Panel/ScrollContainer/MarginContainer/RichTextLabel.text = data[letter]
	show()
	MainCharacter.trackInput = false
