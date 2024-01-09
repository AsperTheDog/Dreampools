extends Control

signal transitionFinished

enum Type {
	FADE,
	WHITE_FADE
}

@export var folksCurve: Curve
@export var deathTitleCurve: Curve

var currentTween: Tween = null
var masterValue: float = 0
@onready var transitions = {
	Type.FADE: [_fade, $CanvasLayer/fade],
	Type.WHITE_FADE: [_whiteFade, $CanvasLayer/fade2]
}


func _ready():
	forceScreen(false)


func doTransition(type: Type, fadeIn: bool, speed: float, forceBeginning: bool = false):
	_prepareType(type)
	if currentTween != null: currentTween.kill()
	if forceBeginning: forceScreen(fadeIn)
	var trueSpeed = (1 - masterValue if fadeIn else masterValue) * speed
	currentTween = create_tween()
	currentTween.tween_method(_execTransFunc.bind(transitions[type][0]), masterValue, 1 if fadeIn else 0, trueSpeed)
	currentTween.tween_callback(func(): transitionFinished.emit())
	currentTween.tween_callback(func(): currentTween = null)


func forceScreen(black: bool):
	masterValue = 0 if black else 1
	for trans in transitions.values():
		trans[0].call(masterValue)


func _prepareType(type: Type):
	for trans in transitions.keys():
		transitions[trans][1].visible = trans == type


func _execTransFunc(value: float, transFunc: Callable):
	masterValue = value
	var vol = lerp(0.0, 1.0, value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(vol))
	transFunc.call(value)


func _fade(value: float):
	$CanvasLayer/fade.color.a = 1 - ease(value, -2)


func _whiteFade(value: float):
	$CanvasLayer/fade2.color.a = 1 - ease(value, -2)


func end():
	$End.show()
	$End.end()
