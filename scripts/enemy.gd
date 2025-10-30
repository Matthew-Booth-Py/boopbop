extends CharacterBody3D

signal enemy_died

@export var speed: float = 2.0
@export var max_health: int = 30
@export var shoot_cooldown: float = 2.0

var health: int = max_health
var shoot_timer: float = 0.0
var player: Node3D = null
var original_material: Material = null
var mesh_instance: MeshInstance3D = null

# Preload scenes
var projectile_scene: PackedScene = preload("res://scenes/projectile.tscn")
var xp_gem_scene: PackedScene = preload("res://scenes/xp_gem.tscn")
var death_particles_scene: PackedScene = preload("res://scenes/death_particles.tscn")
var damage_number_scene: PackedScene = preload("res://scenes/damage_number.tscn")

func _ready() -> void:
	# Set up collision layers
	collision_layer = 2  # Layer 2: Enemy
	collision_mask = 1  # Can collide with Layer 1: Player
	
	shoot_timer = shoot_cooldown
	
	# Store original material for flash effect
	mesh_instance = $MeshInstance3D
	if mesh_instance:
		original_material = mesh_instance.get_active_material(0)
	
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
	
	# Show damage number
	spawn_damage_number(amount)
	
	# Flash effect
	flash_hit()
	
	if health <= 0:
		die()

func flash_hit() -> void:
	if not mesh_instance or not original_material:
		return
	
	# Create white flash material
	var flash_material := StandardMaterial3D.new()
	flash_material.albedo_color = Color(1, 1, 1, 1)
	flash_material.emission_enabled = true
	flash_material.emission = Color(1, 1, 1, 1)
	flash_material.emission_energy_multiplier = 2.0
	
	# Apply flash
	mesh_instance.set_surface_override_material(0, flash_material)
	
	# Tween back to original
	var tween := create_tween()
	tween.tween_callback(func(): mesh_instance.set_surface_override_material(0, null)).set_delay(0.1)

func spawn_damage_number(amount: int) -> void:
	if not damage_number_scene:
		return
	
	var damage_label: Label3D = damage_number_scene.instantiate()
	get_tree().root.add_child(damage_label)
	damage_label.global_position = global_position + Vector3(0, 1, 0)
	damage_label.set_damage(amount)
	damage_label.modulate = Color(1, 0.5, 0.5)  # Red tint for enemy damage

func die() -> void:
	print("Enemy died!")
	
	# Spawn death particles
	spawn_death_particles()
	
	# Spawn XP gem
	spawn_xp_gem()
	
	enemy_died.emit()
	queue_free()

func spawn_death_particles() -> void:
	if not death_particles_scene:
		return
	
	var particles: GPUParticles3D = death_particles_scene.instantiate()
	get_tree().root.add_child(particles)
	particles.global_position = global_position

func spawn_xp_gem() -> void:
	if not xp_gem_scene:
		return
	
	# Create XP gem at enemy position
	var xp_gem: Area3D = xp_gem_scene.instantiate()
	get_tree().root.add_child(xp_gem)
	xp_gem.global_position = global_position + Vector3(0, 0.5, 0)
	
	print("Spawned XP gem at enemy death location")

