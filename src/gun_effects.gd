class_name GunEffects
extends Node

@export var sprite: AnimatedSprite3D
@export var fire_sound: AudioStreamPlayer3D
@export var cock_sound: AudioStreamPlayer3D
@export var light: Node3D


func fire() -> void:
	sprite.set_frame_and_progress(0, 0.0)
	sprite.play()
	fire_sound.play()
	light.visible = true
	await get_tree().create_timer(0.1).timeout
	light.visible = false
	await get_tree().create_timer(0.4).timeout
	cock_sound.play()
	await get_tree().create_timer(0.7).timeout
