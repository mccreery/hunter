extends CharacterBody3D

@export var speed := 2.0
@export var target: Node3D


func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Plane(Vector3.UP) \
			.project(target.transform.origin - transform.origin) \
			.normalized()

	var horz_velocity := direction * speed
	velocity.x = horz_velocity.x
	velocity.z = horz_velocity.z


func _physics_process(_delta: float) -> void:
	move_and_slide()
