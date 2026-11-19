extends Node3D
class_name GameClass


var checkpoint_list: Array[Checkpoint]


func _ready() -> void:
	level_start()


func _process(_delta: float) -> void:
	pass


func level_start() -> void:
	var checkpoint_group_node := get_tree().get_first_node_in_group("checkpoints")
	for node in checkpoint_group_node.get_children():
		if node is Checkpoint:
			checkpoint_list.append(node)


func respawn_player() -> void:
	pass
