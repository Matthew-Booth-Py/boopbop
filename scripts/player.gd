extends CharacterBody3D

signal health_changed(current: int, maximum: int)
signal level_up
signal xp_changed(current: int, needed: int, level: int)

@export var speed: float = 5.0
@export var attack_damage: int = 10
@export var max_health: int = 100

var health: int = max_health
var attack_cooldown: float = 1.0
var attack_timer: float = 0.0
var facing_direction: Vector3 = Vector3.FORWARD  # Track which way player is facing

# XP and leveling system
var player_level: int = 1
var current_xp: int = 0
var xp_to_next_level: int = 10
var is_dead: bool = false

@onready var attack_area: Area3D = $AttackArea
@onready var axe_visual: Node3D = $AxeVisual
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

# Preload particle scenes
var hit_particles_scene: PackedScene = preload("res://scenes/hit_particles.tscn")
var damage_number_scene: PackedScene = preload("res://scenes/damage_number.tscn")

var original_material: Material = null

func _ready() -> void:
	# Set up collision layers
	collision_layer = 1  # Layer 1: Player
	collision_mask = 2  # Can collide with Layer 2: Enemy
	
	if attack_area:
		attack_area.collision_layer = 0
		attack_area.collision_mask = 2  # Can detect Layer 2: Enemy
	
	# Hide axe by default
	if axe_visual:
		axe_visual.visible = false
	
	# Store original material for flash effect
	if mesh_instance:
		original_material = mesh_instance.get_active_material(0)
	
	# Emit initial health
	health_changed.emit(health, max_health)
	
	# Emit initial XP
	xp_changed.emit(current_xp, xp_to_next_level, player_level)

func _physics_process(delta: float) -> void:
	# Don't process if dead
	if is_dead:
		return
	
	# Handle movement
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		# Update facing direction when moving
		facing_direction = snap_to_45_degrees(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
	
	# Handle auto-attack
	attack_timer -= delta
	if attack_timer <= 0:
		perform_attack()
		attack_timer = attack_cooldown

func snap_to_45_degrees(direction: Vector3) -> Vector3:
	# Calculate angle from direction
	var angle: float = atan2(direction.x, direction.z)
	
	# Snap to nearest 45 degrees (PI/4 radians)
	var snap_increment: float = PI / 4.0
	var snapped_angle: float = round(angle / snap_increment) * snap_increment
	
	# Convert back to direction vector
	return Vector3(sin(snapped_angle), 0, cos(snapped_angle)).normalized()

func perform_attack() -> void:
	if not attack_area:
		return
	
	# Show and animate axe
	play_attack_animation()
	
	# Get all enemies in attack range
	var enemies := attack_area.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.has_method("take_damage"):
			enemy.take_damage(attack_damage)
			print("Player attacked enemy for ", attack_damage, " damage")

func play_attack_animation() -> void:
	if not axe_visual:
		return
	
	# Calculate base rotation from facing direction
	var base_angle: float = atan2(facing_direction.x, facing_direction.z)
	
	# Show the axe
	axe_visual.visible = true
	
	# Start position: base angle minus 90 degrees (left side of swing)
	axe_visual.rotation.y = base_angle - PI / 2
	
	# Create tween for swing animation
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	
	# Swing from left to right relative to facing direction (180 degree arc)
	tween.tween_property(axe_visual, "rotation:y", base_angle + PI / 2, 0.3)
	
	# Hide after animation completes
	tween.tween_callback(func(): axe_visual.visible = false)

func take_damage(amount: int) -> void:
	health -= amount
	health = max(0, health)  # Clamp to 0
	print("Player took ", amount, " damage. Health: ", health)
	
	# Spawn hit particles
	spawn_hit_particles()
	
	# Show damage number
	spawn_damage_number(amount)
	
	# Flash effect
	flash_hit()
	
	# Trigger camera shake
	trigger_camera_shake(0.3)
	
	# Emit health change signal
	health_changed.emit(health, max_health)
	
	if health <= 0:
		die()

func flash_hit() -> void:
	if not mesh_instance or not original_material:
		return
	
	# Create red flash material
	var flash_material := StandardMaterial3D.new()
	flash_material.albedo_color = Color(1, 0.3, 0.3, 1)
	flash_material.emission_enabled = true
	flash_material.emission = Color(1, 0, 0, 1)
	flash_material.emission_energy_multiplier = 2.0
	
	# Apply flash
	mesh_instance.set_surface_override_material(0, flash_material)
	
	# Tween back to original
	var tween := create_tween()
	tween.tween_callback(func(): mesh_instance.set_surface_override_material(0, null)).set_delay(0.15)

func spawn_damage_number(amount: int) -> void:
	if not damage_number_scene:
		return
	
	var damage_label: Label3D = damage_number_scene.instantiate()
	get_tree().root.add_child(damage_label)
	damage_label.global_position = global_position + Vector3(0, 1.5, 0)
	damage_label.set_damage(amount)
	damage_label.modulate = Color(1, 0.3, 0.3)  # Red for player damage

func trigger_camera_shake(intensity: float) -> void:
	var camera := get_viewport().get_camera_3d()
	if camera and camera.has_method("shake"):
		camera.shake(intensity)

func spawn_hit_particles() -> void:
	if not hit_particles_scene:
		return
	
	var particles: GPUParticles3D = hit_particles_scene.instantiate()
	get_tree().root.add_child(particles)
	particles.global_position = global_position

func die() -> void:
	print("Player died!")
	is_dead = true
	
	# Trigger game over
	GameManager.game_over()
	
	# Don't queue_free - let game over screen handle it
	# queue_free()

func collect_xp(amount: int) -> void:
	current_xp += amount
	print("Collected ", amount, " XP. Total: ", current_xp, "/", xp_to_next_level)
	
	# Check for level up
	while current_xp >= xp_to_next_level:
		level_up_player()
	
	# Emit XP change signal
	xp_changed.emit(current_xp, xp_to_next_level, player_level)

func level_up_player() -> void:
	player_level += 1
	current_xp -= xp_to_next_level
	
	# Calculate next level threshold (exponential scaling)
	xp_to_next_level = calculate_xp_for_level(player_level + 1)
	
	print("LEVEL UP! Now level ", player_level)
	
	# Pause game and show upgrade choices
	get_tree().paused = true
	level_up.emit()
	
	# Emit XP change signal
	xp_changed.emit(current_xp, xp_to_next_level, player_level)

func calculate_xp_for_level(level: int) -> int:
	# Exponential scaling: 10, 25, 45, 70, 100, 135, 175...
	# Formula: base * level + (level - 1) * 5
	var base: int = 10
	var increment: int = 5
	return base + (level - 1) * (base + (level - 2) * increment)

func apply_upgrade(upgrade_type: String, value: float) -> void:
	match upgrade_type:
		"damage":
			attack_damage += int(value)
			print("Damage increased to ", attack_damage)
		"attack_speed":
			attack_cooldown = max(0.3, attack_cooldown - value)
			print("Attack cooldown reduced to ", attack_cooldown)
		"speed":
			speed += value
			print("Speed increased to ", speed)
		"max_health":
			max_health += int(value)
			health += int(value)  # Also heal the amount
			health_changed.emit(health, max_health)
			print("Max health increased to ", max_health)
		"health_regen":
			# This would need a regen system - placeholder
			print("Health regen upgrade applied")
		_:
			print("Unknown upgrade type: ", upgrade_type)
