extends RigidBody3D
class_name Player


@export var health: float = 100.0
@export var max_health: float = 100.0



var key_left
var key_right
var key_up
var key_down
var key_jump
var state: PhysicsDirectBodyState3D
var max_speed: float = 6.0
var acceleration: float = 5.0
var mouse_sensitivity := 0.15
var condition: BULB_CONDITION


var fall_vector: Vector3 = Vector3.ZERO
var collision_damage_threshold: float = 22.0
var collision_damage_cooldown: float = 0.5

var collision_damage_timer: float = 0.0


enum BULB_CONDITION {
	normal,
	cracked,
	almost_broken,
	broken, # dead state
}


@onready var phantom_camera_3d: PhantomCamera3D = $PhantomCamera3D
@onready var marker_mass_center: Marker3D = $MarkerMassCenter


func _ready() -> void:
	center_of_mass = marker_mass_center.position


func _process(_delta: float) -> void:
	
	if health <= 0.0:
		die()
	
	health = clamp(health, 0.0, max_health)
	
	if health > max_health * 0.66:
		condition = BULB_CONDITION.normal
	elif health > max_health * 0.33:
		condition = BULB_CONDITION.cracked
	elif health > 0.0:
		condition = BULB_CONDITION.almost_broken
	else:
		condition = BULB_CONDITION.broken


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
	
	#if condition == BULB_CONDITION.broken:
		#input = Vector3.ZERO
	
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

	if collision_damage_timer > 0.0:
		collision_damage_timer -= _state.step

	var impact: float = 0.0
	
	for i in range(_state.get_contact_count()):
		
		var collider = _state.get_contact_collider_object(i)
		
		if not collider is Wall:
			continue
		
		var impulse := _state.get_contact_impulse(i)
		var impact_strength := Vector3(impulse.x * 2.0, impulse.y * 0.75, impulse.z * 2.0).length()
		impact = maxf(impact, impact_strength)
	
	if impact > collision_damage_threshold and collision_damage_timer <= 0.0:
		var damage := (impact - collision_damage_threshold)
		take_damage(damage * 2.0)
		collision_damage_timer = collision_damage_cooldown


func is_on_floor() -> bool:
	var on_floor: bool = false
	var i := 0
	if state:
		while i < state.get_contact_count():
			var normal := state.get_contact_local_normal(i)
			on_floor = normal.dot(Vector3.UP) > 0.99
			i += 1
	return on_floor


func die() -> void:
	
	# spawn dead player
	
	#TODO NEED MODEL
	
	# spawn shards
	
	#TODO NEED MODEL
	
	# move player to checkpoint
	
	var active_checkpoint: Checkpoint
	for node in GLOBAL.game.checkpoint_list:
		if node.active:
			active_checkpoint = node
	
	global_position = active_checkpoint.global_position
	
	
	health = 1.00 #TODO what happens after death


func take_damage(damage: float) -> void:
	health -= damage
	UIMANAGER.show_damage_overlay()
	UIMANAGER.set_health(health)
