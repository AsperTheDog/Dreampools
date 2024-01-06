class_name StepPlayer extends AudioStreamPlayer3D

enum StepType {
	WALKING,
	RUNNING,
	WATER,
	SPLASH
}

@export var wakingSteps: Array[AudioStream] = []
@export var runningSteps: Array[AudioStream] = []
@export var waterSteps: Array[AudioStream] = []
@export var splashSteps: Array[AudioStream] = []


func step(type: StepType):
	var list: Array[AudioStream]
	match type:
		StepType.WALKING:
			list = wakingSteps
		StepType.RUNNING:
			list = runningSteps
		StepType.WATER:
			list = waterSteps
		StepType.SPLASH:
			list = splashSteps
	stream = list.pick_random()
	play()
