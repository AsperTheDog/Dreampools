extends Control

var data: Dictionary = preload("res://assets/letters.json").data

var firstLetterShown: bool = false
var currentLetter: String = ""


func _ready():
	hide()


func _process(delta):
	if visible and Input.is_action_just_pressed("pause"):
		hide()
		MainCharacter.trackInput = true
		if not firstLetterShown:
			firstLetterShown = true
			if currentLetter == "letter1" or currentLetter == "letter2":
				get_tree().current_scene.playSubtitle("loop4-father4")
		if currentLetter == "letter4":
			get_tree().current_scene.endGame()


func showLetter(letter: String):
	currentLetter = letter
	$Panel/ScrollContainer/MarginContainer/RichTextLabel.text = data[letter]
	show()
	MainCharacter.trackInput = false
