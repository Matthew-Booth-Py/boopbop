extends Area3D

@export var speed: float = 8.0
@export var damage: int = 5
@export var lifetime: float = 5.0

var direction: Vector3 = Vector3.ZERO
var lifetime_timer: float = 0.0

func _ready() -> void:
	# Set up collision layers
	collision_layer = 4  # Layer 3: Projectiles
	collision_mask = 1  # Can hit Layer 1: Player
	
	# Connect to body entered signal
	body_entered.connect(_on_body_entered)
	
	lifetime_timer = lifetime

func _physics_process(delta: float) -> void:
	# Move in the direction
	if direction != Vector3.ZERO:
		global_position += direction * speed * delta
	
	# Update lifetime
	lifetime_timer -= delta
	if lifetime_timer <= 0:
		queue_free()

func set_direction(dir: Vector3) -> void:
	direction = dir.normalized()

func _on_body_entered(body: Node3D) -> void:
	# Check if we hit the player
	if body.has_method("take_damage"):
		body.take_damage(damage)
		print("Projectile hit player for ", damage, " damage")
		queue_free()

