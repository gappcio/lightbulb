extends Control
class_name UI


@onready var damage_screen: ColorRect = $DamageScreen
@onready var player_health: ProgressBar = $PlayerHealth


func _process(_delta: float) -> void:
	pass


func show_damage_overlay() -> void:
	var tween = create_tween()
	tween.tween_property(damage_screen, "color", Color("ff00004a"), 0.01)
	tween.tween_property(damage_screen, "color", Color("ff000000"), 1.0)


func set_health(health: float) -> void:
	player_health.value = health
