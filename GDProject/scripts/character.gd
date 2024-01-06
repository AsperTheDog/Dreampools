class_name Character extends CharacterBody3D

@onready var head: Node3D = $head
@onready var standingShape: CollisionShape3D = $standingShape
@onready var crouchingShape: CollisionShape3D = $crouchingShape
@onready var standRay = $RayCast3D

const HALF_PI := PI / 2

var current_speed := 5.0

const walking_speed := 5.0
const sprinting_speed := 7.0
const crouching_speed := 3.0
const water_multiplier := 0.6

const jump_prep_crouch := -0.2
const jump_velocity := 8
var prepping_jump := false

var mouse_sens := 0.07

const default_lerp_speed := 7.0
const air_damping := 3.0
const water_damping := 4.0
var lerp_speed := default_lerp_speed

var direction := Vector3.ZERO

var in_water: bool = false:
	set(value):
		if value == in_water: return
		in_water = value
		if not in_water and is_on_floor(): return
		$splash.step(StepPlayer.StepType.SPLASH)

var trackInput: bool = true:
	set(value):
		trackInput = value
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if trackInput else Input.MOUSE_MODE_VISIBLE

@onready var head_height: float = $head.position.y
const crouching_depth := -0.8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	hide()


func _process(delta: float):
	if visible and Input.is_action_just_pressed("pause"):
		if not $Pause.paused:
			$Pause.paused = true
		elif not $Pause.busy:
			$Pause.paused = false
		else:
			Options.hide()
			$Pause.busy = false


var charaRotation: Vector2 = Vector2.ZERO
func _input(event):
	if not trackInput or not visible: return
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		charaRotation.y = rotation.y
		charaRotation.x = head.rotation.x


func _physics_process(delta):
	if not visible: return
	
	var lastCollCount := get_slide_collision_count()
	var tmp_water = false
	for i in lastCollCount:
		var lastColl = get_slide_collision(i)
		if lastColl.get_collider() == null: continue
		if lastColl.get_collider().has_meta("water"):
			tmp_water = true
			break
	in_water = tmp_water
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	applyBob(delta)
	if Input.is_action_pressed("crouch") and trackInput:
		current_speed = crouching_speed
		if not prepping_jump:
			head.position.y = lerp(head.position.y, head_height + crouching_depth, delta * default_lerp_speed)
		else:
			head.position.y = lerp(head.position.y, head_height + crouching_depth + jump_prep_crouch, delta * default_lerp_speed)
		standingShape.disabled = true
		crouchingShape.disabled = false
	elif not standRay.is_colliding():
		if not prepping_jump:
			head.position.y = lerp(head.position.y, head_height, delta * default_lerp_speed)
		else:
			head.position.y = lerp(head.position.y, head_height + jump_prep_crouch, delta * default_lerp_speed)
		standingShape.disabled = false
		crouchingShape.disabled = true
	
		if Input.is_action_pressed("sprint") and trackInput:
			current_speed = sprinting_speed
		else:
			current_speed = walking_speed
	
	if in_water:
		current_speed = current_speed * water_multiplier
	
	if not prepping_jump:
		if Input.is_action_just_pressed("jump") and is_on_floor() and trackInput:
			prepping_jump = true
	else:
		if not is_on_floor():
			prepping_jump = false
		elif Input.is_action_just_released("jump") and trackInput:
			velocity.y = jump_velocity
	
	if in_water:
		lerp_speed = default_lerp_speed / water_damping
	elif not is_on_floor():
		lerp_speed = default_lerp_speed / air_damping
	else:
		lerp_speed = default_lerp_speed
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back") if trackInput else Vector2.ZERO
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_speed)

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()


var time: float = 0
var intensity: float = 1
var nextInterval: float = HALF_PI + PI
func applyBob(delta):
	const midSpeed := (sprinting_speed + walking_speed) / 2
	if is_on_floor():
		intensity = lerp(intensity, inverse_lerp(0, sprinting_speed, velocity.length()), 0.3)
	else:
		intensity = lerp(intensity, inverse_lerp(0, sprinting_speed, 0.0), 0.3)
	time += delta * velocity.length() * 1.5
	var ySin := sin(time * 2)
	var xOffset := sin(time) * 0.15 * intensity
	var yOffset := ySin * 0.05 * intensity
	$head/Camera3D.position.x = xOffset
	$head/Camera3D.position.y = yOffset
	if time * 2 >= nextInterval and is_on_floor():
		if in_water:
			$steps.volume_db = max(-15, linear_to_db(inverse_lerp(0.1, 0.6, clamp(intensity, 0.1, 0.6))) * 2) - 15
			$steps.step(StepPlayer.StepType.WATER)
		else:
			$steps.volume_db = linear_to_db(inverse_lerp(0.2, 1, clamp(intensity, 0.2, 1))) * 3
			$steps.step(StepPlayer.StepType.WALKING if intensity <= midSpeed else StepPlayer.StepType.RUNNING)
		nextInterval += PI * 2

func setLookingPos(dir: Vector2):
	rotation.y = dir.y
	head.rotation.x = dir.x


func _on_visibility_changed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if visible else Input.MOUSE_MODE_VISIBLE
