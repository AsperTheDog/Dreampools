extends Area3D

@export var dialogue: String

@export_group("Modifications")
@export var continuations: Array[DialogueCont]

var triggered: bool = false


func _ready():
	body_entered.connect(on_body_enter)


func on_body_enter(body: PhysicsBody3D):
	if triggered: return
	triggered = true
	owner.playSubtitle(dialogue)
	for cont in continuations:
		if cont.loops > 0:
			for loop in cont.loops:
				await get_tree().create_timer(cont.delay).timeout
				if cont.dialogue != "":
					owner.playSubtitle(cont.dialogue)
		else:
			while true:
				await get_tree().create_timer(cont.delay).timeout
				if cont.dialogue != "":
					owner.playSubtitle(cont.dialogue)
