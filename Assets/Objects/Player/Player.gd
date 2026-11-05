extends RigidBody3D
class_name Player


var key_left
var key_right
var key_up
var key_down
var key_jump
var state: PhysicsDirectBodyState3D
var max_speed: float = 6.0
var acceleration: float = 5.0


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
	key_jump = Input.is_action_just_pressed("jump")
	
	var input := Vector3.ZERO
	input.x = Input.get_axis("left", "right")
	input.z = Input.get_axis("forward", "backward")
	input = input.normalized()
	
	apply_central_force(input * acceleration * mass)
	
	var horizontal_velocity = Vector3(linear_velocity.x, 0, linear_velocity.z)
	
	if horizontal_velocity.length() > max_speed:
		horizontal_velocity = horizontal_velocity.normalized() * max_speed
		linear_velocity.x = horizontal_velocity.x
		linear_velocity.z = horizontal_velocity.z
	
	apply_torque(Vector3(input.z, 0, -input.x) * 3.0)
	
	if key_jump:
		apply_impulse(Vector3(0.0, 10.0, 0.0))
	
	#print(is_on_floor())
	
	#apply_central_force(dir)
	#apply_impulse(dir)


func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	state = _state


func is_on_floor() -> bool:
	var on_floor: bool = false
	var i := 0
	if state:
		while i < state.get_contact_count():
			var normal := state.get_contact_local_normal(i)
			on_floor = normal.dot(Vector3.UP) > 0.99
			i += 1
	return on_floor
