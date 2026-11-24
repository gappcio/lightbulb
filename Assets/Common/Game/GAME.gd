extends Node3D
class_name GameClass


var checkpoint_list: Array[Checkpoint]
var level: Node3D
@onready var level_container: Node3D = $LEVEL_CONTAINER
var player_dead

func _ready() -> void:
	level_start()


func _process(_delta: float) -> void:
	pass


func level_start() -> void:
	level = level_container.get_child(0)
	var checkpoint_group_node := get_tree().get_first_node_in_group("checkpoints")
	for node in checkpoint_group_node.get_children():
		if node is Checkpoint:
			checkpoint_list.append(node)
	
	await get_tree().create_timer(0.1).timeout
	
	spawn_dead_player()



func spawn_dead_player() -> void:
	var player_dead_node = load("uid://cr4hlvaxgld5v")
	player_dead = player_dead_node.instantiate()
	if level:
		level.call_deferred("add_child", player_dead)
		await get_tree().create_timer(0.1).timeout
		player_dead.global_position = Vector3(0.0, -100000.0, 0.0)
		player_dead.preload_smashed_mesh()


func respawn_player() -> void:
	pass
