extends Label3D

var float_speed: float = 2.0
var lifetime: float = 1.0
var fade_start: float = 0.5

func _ready() -> void:
	# Start animation
	animate()

func set_damage(amount: int) -> void:
	text = str(amount)

func animate() -> void:
	# Create tween for movement and fade
	var tween := create_tween()
	tween.set_parallel(true)
	
	# Float upward
	tween.tween_property(self, "position:y", position.y + float_speed, lifetime)
	
	# Fade out after fade_start time
	tween.tween_property(self, "modulate:a", 0.0, lifetime - fade_start).set_delay(fade_start)
	
	# Free after animation
	tween.tween_callback(queue_free).set_delay(lifetime)

