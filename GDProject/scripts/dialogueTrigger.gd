extends Area3D

@export var dialogue: String


func _ready():
	body_entered.connect(on_body_enter)


func on_body_enter(body: PhysicsBody3D):
	owner.playSubtitle(dialogue)
