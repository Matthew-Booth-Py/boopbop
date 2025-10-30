extends Camera3D

var trauma: float = 0.0
var trauma_decay: float = 1.5  # How fast trauma decays per second
var max_offset: float = 0.5  # Maximum camera offset
var max_rotation: float = 0.1  # Maximum rotation in radians

var original_position: Vector3
var original_rotation: Vector3

func _ready() -> void:
	original_position = position
	original_rotation = rotation

func _process(delta: float) -> void:
	# Decay trauma over time
	if trauma > 0:
		trauma = max(trauma - trauma_decay * delta, 0.0)
		apply_shake()
	else:
		# Reset to original position when no trauma
		position = original_position
		rotation = original_rotation

func shake(intensity: float, duration: float = 0.5) -> void:
	# Add trauma (clamped to 0-1)
	trauma = min(trauma + intensity, 1.0)
	
	# Adjust decay based on duration
	trauma_decay = intensity / duration

func apply_shake() -> void:
	# Use trauma squared for more dramatic effect at higher values
	var shake_amount: float = trauma * trauma
	
	# Random offset
	var offset_x: float = randf_range(-max_offset, max_offset) * shake_amount
	var offset_y: float = randf_range(-max_offset, max_offset) * shake_amount
	var offset_z: float = randf_range(-max_offset, max_offset) * shake_amount
	
	# Random rotation
	var rot_x: float = randf_range(-max_rotation, max_rotation) * shake_amount
	var rot_y: float = randf_range(-max_rotation, max_rotation) * shake_amount
	var rot_z: float = randf_range(-max_rotation, max_rotation) * shake_amount
	
	# Apply shake
	position = original_position + Vector3(offset_x, offset_y, offset_z)
	rotation = original_rotation + Vector3(rot_x, rot_y, rot_z)

