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
var mouse_sensitivity := 0.15

@onready var phantom_camera_3d: PhantomCamera3D = $PhantomCamera3D


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _unhandled_input(event) -> void:
  # Trigger whenever the mouse moves.
	if event is InputEventMouseMotion:
		var pcam_rotation_degrees: Vector3
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Assigns the current 3D rotation of the SpringArm3D node - to start off where it is in the editor.
		pcam_rotation_degrees = phantom_camera_3d.get_third_person_rotation_degrees()

	# Change the X rotation.
		pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity
		
	# Clamp the rotation in the X axis so it can go over or under the target.
		pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, -80.0, 80.0)

	# Change the Y rotation value.
		pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity
		
	# Sets the rotation to fully loop around its target, but without going below or exceeding 0 and 360 degrees respectively.
		pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, 0.0, 360.0)
		
	# Change the SpringArm3D node's rotation and rotate around its target.
		phantom_camera_3d.set_third_person_rotation_degrees(pcam_rotation_degrees)


func _physics_process(delta: float) -> void:
	key_left = Input.is_action_pressed("left")
	key_right = Input.is_action_pressed("right")
	key_up = Input.is_action_pressed("forward")
	key_down = Input.is_action_pressed("backward")
	key_jump = Input.is_action_just_pressed("jump")
	
	var input := Vector3.ZERO
	input.x = Input.get_axis("left", "right")
	input.z = Input.get_axis("forward", "backward")
	input = input.rotated(Vector3.UP, phantom_camera_3d.get_third_person_rotation().y)
	input = input.normalized()
	
	apply_central_force(input * acceleration * mass)
	
	var horizontal_velocity = Vector3(linear_velocity.x, 0, linear_velocity.z)
	
	if horizontal_velocity.length() > max_speed:
		horizontal_velocity = horizontal_velocity.normalized() * max_speed
		linear_velocity.x = horizontal_velocity.x
		linear_velocity.z = horizontal_velocity.z
	
	apply_torque(Vector3(input.z, 0, -input.x) * 3.0)
	
	if key_jump and is_on_floor():
		apply_impulse(Vector3(0.0, 20.0, 0.0))


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
