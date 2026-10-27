extends RigidBody3D
class_name Player


var key_left
var key_right
var key_up
var key_down

@onready var phantom_camera_3d: PhantomCamera3D = $PhantomCamera3D

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	key_left = Input.is_action_pressed("left")
	key_right = Input.is_action_pressed("right")
	key_up = Input.is_action_pressed("forward")
	key_down = Input.is_action_pressed("backward")
	
	var dir : Vector3 = Vector3.ZERO
	dir.x = int(key_right) - int(key_left)
	dir.z = int(key_down) - int(key_up)
	dir = dir.rotated(Vector3.UP, phantom_camera_3d.rotation.y)
	
	#apply_central_force(dir)
	apply_impulse(dir)
