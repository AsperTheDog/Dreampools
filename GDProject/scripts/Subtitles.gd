extends Control

@onready var subtitles: Dictionary = preload("res://assets/subtitles.json").data

@export var characterColors: Dictionary = {
	"father": Color("cc9238"),
	"narrator": Color(0, 0, 0, 1.0)
}

var currentSubs = {}


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = Options.subtitles
	Options.changedSubtitles.connect(func(active): visible = active)


func startSubtitle(subtitle: String):
	removeSubtitle(subtitle)
	var label = RichTextLabel.new()
	label.name = subtitle
	label.fit_content = true
	label.bbcode_enabled = true
	label.set("theme_override_font_sizes/normal_font_size", 20)
	label.set("theme_override_constants/outline_size", 6)
	label.set("theme_override_colors/default_color", Color.WHITE)
	$subtitleContainer.add_child(label)
	$subtitleContainer.move_child(label, 0)
	currentSubs[subtitle] = {"label": label, "tween": null}
	var tween = create_tween()
	for stage in subtitles[subtitle].size():
		tween.tween_callback(_assignSubtitle.bind(subtitle, stage))
		tween.tween_interval(subtitles[subtitle][stage]["duration"])
	tween.tween_callback(removeSubtitle.bind(subtitle))
	currentSubs[subtitle]["tween"] = tween


func removeSubtitle(subtitle: String):
	if not subtitle in currentSubs:
		return
	currentSubs[subtitle]["tween"].kill()
	currentSubs[subtitle]["label"].queue_free()
	currentSubs.erase(subtitle)


func _assignSubtitle(subtitle: String, stage: int):
	currentSubs[subtitle]["label"].text = "[center]"+subtitles[subtitle][stage]["text"]+"[/center]"
	var charaData: Color = characterColors[subtitles[subtitle][stage]["character"]]
	currentSubs[subtitle]["label"].set("theme_override_colors/font_outline_color", charaData)
