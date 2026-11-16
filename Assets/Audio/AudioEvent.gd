extends Resource
class_name AudioEvent

@export var id: StringName
@export var stream: AudioStream

@export_group("Playback")
@export_range(-40.0, 6.0) var volume_db: float = 0.0
@export_range(0.1, 3.0) var pitch_min: float = 1.0
@export_range(0.1, 3.0) var pitch_max: float = 1.0

@export_group("Bus")
@export var bus: StringName = &"SFX"
