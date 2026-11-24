extends Node3D


@onready var stm_instance: STMInstance3D = $STMInstance3D
var saved_shards_positions: Dictionary

func preload_smashed_mesh() -> void:
	if stm_instance:
		stm_instance.smash_the_mesh()
		stm_instance.chunks_freeze(true)
		
		await get_tree().create_timer(0.01).timeout
		
		# save shards positions
		var transform_callback_save = func(rb: RigidBody3D, _from):
			saved_shards_positions[rb] = rb.transform
		stm_instance.chunks_iterate(transform_callback_save)


func explode(_transform: Transform3D) -> void:
	await get_tree().create_timer(0.01).timeout
	
	# move parent to player
	stm_instance.rb_parent.global_transform = _transform
	
	stm_instance.chunks_freeze(false)
	var explode_callback = func(rb: RigidBody3D, _from):
		rb.apply_impulse(-rb.global_position.normalized() * Vector3(randf_range(-1.0, 1.0), randf_range(0.0, 1.0), randf_range(-1.0, 1.0)) * 2.0)
	stm_instance.chunks_iterate(explode_callback)
	
	await get_tree().create_timer(5.0).timeout
	# reset positions
	stm_instance.chunks_freeze(true)
	var transform_callback_load = func(rb: RigidBody3D, _from):
		rb.transform = saved_shards_positions[rb]
	stm_instance.chunks_iterate(transform_callback_load)
	stm_instance.rb_parent.global_position = Vector3(0.0, -100000.0, 0.0)
	stm_instance.rb_parent.global_rotation = Vector3(0.0, 0.0, 0.0)
