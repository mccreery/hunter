class_name BaseEnemy
extends CharacterBody3D

@export var speed := 2.0
@export var target: Node3D

@export var body_shot_damage := 0.5
@export var head_shot_damage := 1.0
@export var hit_sound: AudioStream
@export var corpse_resource: PackedScene

var sfx_resource = preload("res://assets/scenes/one_shot_sfx.tscn")
var health := 1.0


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


func hit(is_head_shot: bool) -> void:
	health -= head_shot_damage if is_head_shot else body_shot_damage

	var sfx := sfx_resource.instantiate() as AudioStreamPlayer3D
	sfx.transform = transform
	sfx.stream = hit_sound
	sfx.pitch_scale = randf_range(0.8, 0.9)
	get_tree().get_root().add_child(sfx)

	if health <= 0.0:
		var corpse := corpse_resource.instantiate() as Node3D
		corpse.transform = transform
		get_tree().get_root().add_child(corpse)
		queue_free()
