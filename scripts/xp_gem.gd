extends Area3D

@export var xp_value: int = 5
@export var magnetic_range: float = 5.0
@export var move_speed: float = 10.0
@export var lifetime: float = 30.0

var player: Node3D = null
var is_attracted: bool = false
var lifetime_timer: float = 0.0

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	# Set up collision layers
	collision_layer = 8  # Layer 4: Pickups
	collision_mask = 1  # Can detect Layer 1: Player
	
	# Connect to body entered signal
	body_entered.connect(_on_body_entered)
	
	lifetime_timer = lifetime
	
	# Find the player
	call_deferred("find_player")
	
	# Start pulse animation
	start_pulse_animation()

func find_player() -> void:
	var root := get_tree().root
	player = root.find_child("Player", true, false)

func _physics_process(delta: float) -> void:
	# Update lifetime
	lifetime_timer -= delta
	if lifetime_timer <= 0:
		queue_free()
		return
	
	if not player:
		return
	
	# Check distance to player
	var distance := global_position.distance_to(player.global_position)
	
	# Activate magnetic attraction if within range
	if distance < magnetic_range:
		is_attracted = true
	
	# Move toward player if attracted
	if is_attracted:
		var direction := (player.global_position - global_position).normalized()
		global_position += direction * move_speed * delta

func start_pulse_animation() -> void:
	if not mesh_instance:
		return
	
	# Create pulsing scale animation
	var tween := create_tween()
	tween.set_loops()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(mesh_instance, "scale", Vector3(1.2, 1.2, 1.2), 0.5)
	tween.tween_property(mesh_instance, "scale", Vector3(1.0, 1.0, 1.0), 0.5)

func _on_body_entered(body: Node3D) -> void:
	# Check if we hit the player
	if body.has_method("collect_xp"):
		body.collect_xp(xp_value)
		queue_free()

