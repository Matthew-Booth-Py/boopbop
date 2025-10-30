extends CharacterBody3D

@export var speed: float = 5.0
@export var attack_damage: int = 10
@export var max_health: int = 100

var health: int = max_health
var attack_cooldown: float = 1.0
var attack_timer: float = 0.0

@onready var attack_area: Area3D = $AttackArea
@onready var axe_visual: Node3D = $AxeVisual

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

func _physics_process(delta: float) -> void:
	# Handle movement
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
	
	# Handle auto-attack
	attack_timer -= delta
	if attack_timer <= 0:
		perform_attack()
		attack_timer = attack_cooldown

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
	
	# Show the axe
	axe_visual.visible = true
	
	# Reset rotation
	axe_visual.rotation.y = -PI / 2  # Start position (-90 degrees)
	
	# Create tween for swing animation
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	
	# Swing from left to right (180 degree arc)
	tween.tween_property(axe_visual, "rotation:y", PI / 2, 0.3)
	
	# Hide after animation completes
	tween.tween_callback(func(): axe_visual.visible = false)

func take_damage(amount: int) -> void:
	health -= amount
	print("Player took ", amount, " damage. Health: ", health)
	
	if health <= 0:
		die()

func die() -> void:
	print("Player died!")
	queue_free()

