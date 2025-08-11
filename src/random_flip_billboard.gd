extends MeshInstance3D

@export var size: Vector2
@export var material: StandardMaterial3D


func _ready() -> void:
	var flip := randi() & 1 == 0

	var mesh := QuadMesh.new()
	mesh.size = Vector2(-size.x, size.y) if flip else size
	mesh.material = material
	self.mesh = mesh
