extends Node3D
class_name Checkpoint


#@export var checkpoint_id: int
@export var active: bool = false:
	get:
		return active
	set(value):
		active = value
		if mesh:
			if active:
				mesh.set_surface_override_material(0, GLOBAL.MAT_CHECKPOINT_ACTIVE)
			else:
				mesh.set_surface_override_material(0, GLOBAL.MAT_CHECKPOINT_DISABLED)


@onready var mesh: MeshInstance3D = $Mesh


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		for _checkpoint in GLOBAL.game.checkpoint_list:
			_checkpoint.active = false
		active = true
