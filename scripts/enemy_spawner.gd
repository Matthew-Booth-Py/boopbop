extends Node3D

@export var initial_spawn_interval: float = 5.0
@export var min_spawn_interval: float = 1.0
@export var initial_enemies_per_wave: int = 1
@export var max_enemies_per_wave: int = 5
@export var spawn_distance_min: float = 10.0
@export var spawn_distance_max: float = 15.0
@export var arena_radius: float = 20.0
@export var difficulty_increase_interval: float = 30.0

var current_spawn_interval: float
var current_enemies_per_wave: int
var time_elapsed: float = 0.0
var player: Node3D = null

var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")

@onready var spawn_timer: Timer = Timer.new()
@onready var difficulty_timer: Timer = Timer.new()
@onready var game_ui: CanvasLayer = null

func _ready() -> void:
	# Initialize values
	current_spawn_interval = initial_spawn_interval
	current_enemies_per_wave = initial_enemies_per_wave
	
	# Set up spawn timer
	add_child(spawn_timer)
	spawn_timer.wait_time = current_spawn_interval
	spawn_timer.one_shot = false
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()
	
	# Set up difficulty timer
	add_child(difficulty_timer)
	difficulty_timer.wait_time = difficulty_increase_interval
	difficulty_timer.one_shot = false
	difficulty_timer.timeout.connect(_on_difficulty_timer_timeout)
	difficulty_timer.start()
	
	# Find player
	call_deferred("find_player")
	call_deferred("find_game_ui")

func find_player() -> void:
	var root := get_tree().root
	player = root.find_child("Player", true, false)
	if not player:
		print("Warning: Player not found for enemy spawner")

func find_game_ui() -> void:
	var root := get_tree().root
	game_ui = root.find_child("GameUI", true, false)

func _on_spawn_timer_timeout() -> void:
	if player:
		spawn_wave()

func spawn_wave() -> void:
	for i in range(current_enemies_per_wave):
		spawn_enemy()

func spawn_enemy() -> void:
	if not player or not enemy_scene:
		return
	
	# Calculate spawn position
	var spawn_pos: Vector3 = get_spawn_position()
	
	# Instantiate enemy
	var enemy: Node3D = enemy_scene.instantiate()
	get_tree().root.add_child(enemy)
	enemy.global_position = spawn_pos
	
	# Connect enemy death signal to UI if available
	if game_ui and enemy.has_signal("enemy_died"):
		enemy.enemy_died.connect(game_ui.increment_kills)
	
	print("Spawned enemy at: ", spawn_pos)

func get_spawn_position() -> Vector3:
	# Generate random angle
	var angle: float = randf() * TAU
	
	# Random distance between min and max
	var distance: float = randf_range(spawn_distance_min, spawn_distance_max)
	
	# Calculate position relative to player
	var offset := Vector3(
		cos(angle) * distance,
		0,
		sin(angle) * distance
	)
	
	var spawn_pos := player.global_position + offset
	
	# Clamp to arena bounds
	spawn_pos.x = clamp(spawn_pos.x, -arena_radius, arena_radius)
	spawn_pos.z = clamp(spawn_pos.z, -arena_radius, arena_radius)
	
	return spawn_pos

func _on_difficulty_timer_timeout() -> void:
	increase_difficulty()

func increase_difficulty() -> void:
	# Decrease spawn interval (faster spawns)
	current_spawn_interval = max(min_spawn_interval, current_spawn_interval - 0.5)
	spawn_timer.wait_time = current_spawn_interval
	
	# Increase enemies per wave
	current_enemies_per_wave = min(max_enemies_per_wave, current_enemies_per_wave + 1)
	
	print("Difficulty increased! Interval: ", current_spawn_interval, " Enemies per wave: ", current_enemies_per_wave)

