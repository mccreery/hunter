extends CharacterBody3D

const RADIANS_PER_DOT = deg_to_rad(0.022)
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var pitch := 0.0
var yaw := 0.0

@export var camera: Node3D
@export var mouse_sensitivity := 3.5


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Release the mouse if the window loses focus
	get_viewport().focus_exited.connect(func() -> void:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE)


# Recapture the mouse when the player clicks the window
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed \
			and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED \
			and event is InputEventMouseMotion:
		var relative_angle = RADIANS_PER_DOT * mouse_sensitivity * event.relative

		pitch -= relative_angle.y
		pitch = clampf(pitch, -PI / 2.0, PI / 2.0)

		yaw -= relative_angle.x
		yaw = fmod(yaw, TAU)

		transform.basis = Basis.IDENTITY.rotated(Vector3.UP, yaw)
		camera.transform.basis = Basis.IDENTITY.rotated(Vector3.RIGHT, pitch)


func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


func _physics_process(delta: float) -> void:
	move_and_slide()
