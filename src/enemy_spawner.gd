extends Node3D

@export var enemy: PackedScene
@export var enemy_target: Node3D
@export var min_radius := 30.0
@export var max_radius := 50.0
@export var min_wait := 3.0
@export var max_wait := 5.0
@export var max_enemies := 10


func _ready() -> void:
	# Alternate between spawning and waiting to spawn
	while true:
		# Spawn enemy somewhere in a doughnut shape around the spawner
		if get_child_count() < max_enemies:
			var enemy: BaseEnemy = enemy.instantiate()
			var direction := Vector3.FORWARD.rotated(Vector3.UP, randf() * TAU)
			var distance := randf_range(min_radius, max_radius)
			enemy.transform.origin = direction * distance
			enemy.target = enemy_target
			add_child(enemy)

		# Wait
		var wait := randf_range(min_wait, max_wait)
		await get_tree().create_timer(wait).timeout
