extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var pitch := 0.0
var yaw := 0.0

@export var camera: Node3D


func _ready() -> void:
	get_viewport().focus_entered.connect(func() -> void:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED)
	get_viewport().focus_exited.connect(func() -> void:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE)


func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED \
			and event is InputEventMouseMotion:
		pitch -= event.relative.y * 0.01
		pitch = clampf(pitch, -PI / 2.0, PI / 2.0)
		
		yaw -= event.relative.x * 0.01
		yaw = fmod(yaw, TAU)
		
		transform.basis = Basis.IDENTITY.rotated(Vector3.UP, yaw)
		camera.transform.basis = Basis.IDENTITY.rotated(Vector3.RIGHT, pitch)


func _process(delta: float) -> void:
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

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

	move_and_slide()
