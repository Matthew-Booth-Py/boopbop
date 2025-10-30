extends CharacterBody3D

signal enemy_died

@export var speed: float = 2.0
@export var max_health: int = 30
@export var shoot_cooldown: float = 2.0

var health: int = max_health
var shoot_timer: float = 0.0
var player: Node3D = null

# Preload the projectile scene
var projectile_scene: PackedScene = preload("res://scenes/projectile.tscn")

func _ready() -> void:
	# Set up collision layers
	collision_layer = 2  # Layer 2: Enemy
	collision_mask = 1  # Can collide with Layer 1: Player
	
	shoot_timer = shoot_cooldown
	
	# Find the player in the scene
	call_deferred("find_player")

func find_player() -> void:
	var root := get_tree().root
	player = root.find_child("Player", true, false)

func _physics_process(delta: float) -> void:
	if not player:
		return
	
	# Move toward player
	var direction := (player.global_position - global_position).normalized()
	direction.y = 0  # Keep movement on XZ plane
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	move_and_slide()
	
	# Handle shooting
	shoot_timer -= delta
	if shoot_timer <= 0:
		shoot_at_player()
		shoot_timer = shoot_cooldown

func shoot_at_player() -> void:
	if not player or not projectile_scene:
		return
	
	# Spawn a projectile
	var projectile: Area3D = projectile_scene.instantiate()
	get_tree().root.add_child(projectile)
	
	# Position it at enemy location
	projectile.global_position = global_position + Vector3(0, 1, 0)
	
	# Calculate direction to player
	var direction := (player.global_position - global_position).normalized()
	projectile.set_direction(direction)
	
	print("Enemy shot projectile at player")

func take_damage(amount: int) -> void:
	health -= amount
	print("Enemy took ", amount, " damage. Health: ", health)
	
	if health <= 0:
		die()

func die() -> void:
	print("Enemy died!")
	enemy_died.emit()
	queue_free()

