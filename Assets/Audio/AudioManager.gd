extends Node
class_name AudioManager


@export var events: Array[AudioEvent] = []
@export_range(1, 64) var max_events: int = 16


var sound_library: Dictionary = {}
var players: Array[AudioStreamPlayer] = []
var next_player: int = 0


func _ready() -> void:
	for event in events:
		if event != null:
			sound_library[event.id] = event
	
	for i in range(max_events):
		var player := AudioStreamPlayer.new()
		add_child(player)
		players.append(player)


func play_sfx(id: StringName) -> void:
	if not sound_library.has(id):
		return
	var event: AudioEvent = sound_library[id]
	if event.stream == null:
		return
	var player := players[next_player]
	next_player = (next_player + 1) % players.size()
	player.stop()
	
	player.stream = event.stream
	player.volume_db = event.volume_db
	player.bus = event.bus
	player.pitch_scale = randf_range(
		event.pitch_min,
		event.pitch_max
	)
	
	player.play()
