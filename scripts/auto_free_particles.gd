extends GPUParticles3D

func _ready() -> void:
	# Wait for particles to finish, then free
	finished.connect(_on_finished)

func _on_finished() -> void:
	queue_free()

