extends CharacterBody3D

@onready var head: Node3D = $head
@onready var standingShape: CollisionShape3D = $standingShape
@onready var crouchingShape: CollisionShape3D = $crouchingShape
@onready var standRay = $RayCast3D

var current_speed := 5.0

const walking_speed := 5.0
const sprinting_speed := 7.0
const crouching_speed := 3.0

const jump_prep_crouch := -0.2
const jump_velocity := 8
var prepping_jump := false

const mouse_sens := 0.07

const default_lerp_speed := 7.0
const air_damping := 3.0
var lerp_speed := default_lerp_speed

var direction := Vector3.ZERO

@onready var head_height: float = $head.position.y
const crouching_depth := -0.8

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))


func _physics_process(delta):
	applyBob(delta)
	if Input.is_action_pressed("crouch"):
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
	
		if Input.is_action_pressed("sprint"):
			current_speed = sprinting_speed
		else:
			current_speed = walking_speed
		
	if not prepping_jump:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			prepping_jump = true
	else:
		if not is_on_floor():
			prepping_jump = false
		elif Input.is_action_just_released("jump"):
			velocity.y = jump_velocity
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		lerp_speed = default_lerp_speed / air_damping
	else:
		lerp_speed = default_lerp_speed
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
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
func applyBob(delta):
	if is_on_floor():
		intensity = lerp(intensity, inverse_lerp(0, sprinting_speed, velocity.length()), 0.3)
	else:
		intensity = lerp(intensity, inverse_lerp(0, sprinting_speed, 0.0), 0.3)
	time += delta * velocity.length() * 1.5
	var xOffset := sin(time) * 0.15 * intensity
	var yOffset := sin(time * 2) * 0.05 * intensity
	$head/Camera3D.position.x = xOffset
	$head/Camera3D.position.y = yOffset
