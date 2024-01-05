extends Control

signal changedVisibility(isVisible: bool)

var subtitles: bool = true


func _on_visibility_changed():
	changedVisibility.emit(visible)


@onready var windowModeSelect: OptionButton = $Panel/MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/WindowMode/OptionButton
func _on_window_mode(index: int):
	DisplayServer.window_set_mode(windowModeSelect.get_item_id(index))


@onready var vSyncSelect: OptionButton = $Panel/MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/VSync/OptionButton
func _on_VSync(index: int): 
	DisplayServer.window_set_vsync_mode(vSyncSelect.get_item_id(index))


@onready var antialiasingSelect: OptionButton = $Panel/MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/MSAA/OptionButton
func _on_antialiasing(index: int):
	get_viewport().msaa_3d = antialiasingSelect.get_item_id(index) as Viewport.MSAA


func _on_subtitles(index: int):
	subtitles = index == 0


@onready var mouseText: RichTextLabel = $Panel/MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/Mouse/RichTextLabel
func _on_mouse_sensitivity(value: float):
	mouseText.text = "Mouse Sensitivity (" + str(value * 10) + ")"
	MainCharacter.mouse_sens = value


@onready var masterVolumeText: RichTextLabel = $Panel/MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/MasterVolume/RichTextLabel
func _on_master_volume(value: float):
	masterVolumeText.text = "Master Volume (" + str(int(value * 100)) + "%)"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))


@onready var voiceVolumeText: RichTextLabel = $Panel/MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/VoiceVolume/RichTextLabel
func _on_voice_volume(value: float):
	voiceVolumeText.text = "Master Volume (" + str(int(value * 100)) + "%)"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"), linear_to_db(value))


@onready var effectsVolumeText: RichTextLabel = $Panel/MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/EffectsVolume/RichTextLabel
func _on_effects_volume(value: float):
	effectsVolumeText.text = "Master Volume (" + str(int(value * 100)) + "%)"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Effects"), linear_to_db(value))


@onready var musicVolumeText: RichTextLabel = $Panel/MarginContainer/ScrollContainer/MarginContainer/VBoxContainer/MusicVolume/RichTextLabel
func _on_music_volume(value: float):
	musicVolumeText.text = "Master Volume (" + str(int(value * 100)) + "%)"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
