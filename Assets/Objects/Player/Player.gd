extends RigidBody3D
class_name Player


var key_left
var key_right
var key_up
var key_down
var key_jump
var state_bulb: PhysicsDirectBodyState3D
var state_stem: PhysicsDirectBodyState3D

@onready var phantom_camera_3d: PhantomCamera3D = $PhantomCamera3D
@onready var stem: RigidBody3D = $Stem

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	key_left = Input.is_action_pressed("left")
	key_right = Input.is_action_pressed("right")
	key_up = Input.is_action_pressed("forward")
	key_down = Input.is_action_pressed("backward")
	key_jump = Input.is_action_just_pressed("jump")
	
	var dir : Vector3 = Vector3.ZERO
	dir.x = int(key_right) - int(key_left)
	dir.z = int(key_down) - int(key_up)
	dir = dir.rotated(Vector3.UP, phantom_camera_3d.rotation.y)
	
	if key_jump:
		apply_impulse(Vector3(0.0, 10.0, 0.0))
	
	print(is_on_floor())
	
	#apply_central_force(dir)
	apply_impulse(dir)


func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	state_bulb = _state


func is_on_floor() -> bool:
	var on_floor: bool = false
	var i := 0
	if state_bulb:
		while i < state_bulb.get_contact_count():
			var normal := state_bulb.get_contact_local_normal(i)
			on_floor = normal.dot(Vector3.UP) > 0.99
			i += 1
	return on_floor
