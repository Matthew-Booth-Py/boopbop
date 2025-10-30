extends Node

enum GameState {
	PLAYING,
	PAUSED,
	GAME_OVER
}

var current_state: GameState = GameState.PLAYING

# Run statistics
var current_kills: int = 0
var current_time: float = 0.0
var current_level: int = 1

# High scores
var high_score_kills: int = 0
var high_score_time: float = 0.0
var high_score_level: int = 1

var config_file: ConfigFile = ConfigFile.new()
var save_path: String = "user://highscores.cfg"

func _ready() -> void:
	load_high_scores()

func game_over() -> void:
	current_state = GameState.GAME_OVER
	
	# Get stats from game
	update_current_stats()
	
	# Check and update high scores
	update_high_scores()
	
	# Show game over UI
	show_game_over_ui()

func update_current_stats() -> void:
	# Find GameUI to get stats
	var game_ui := get_tree().root.find_child("GameUI", true, false)
	if game_ui:
		current_kills = game_ui.kill_count
		current_time = game_ui.time_elapsed
	
	# Find Player to get level
	var player := get_tree().root.find_child("Player", true, false)
	if player and player.has("player_level"):
		current_level = player.player_level

func update_high_scores() -> void:
	var updated: bool = false
	
	if current_kills > high_score_kills:
		high_score_kills = current_kills
		updated = true
	
	if current_time > high_score_time:
		high_score_time = current_time
		updated = true
	
	if current_level > high_score_level:
		high_score_level = current_level
		updated = true
	
	if updated:
		save_high_scores()

func show_game_over_ui() -> void:
	# Find or create game over UI
	var game_over_ui := get_tree().root.find_child("GameOverUI", true, false)
	if game_over_ui and game_over_ui.has_method("show_game_over"):
		game_over_ui.show_game_over(current_kills, current_time, current_level)

func restart_game() -> void:
	# Reset state
	current_state = GameState.PLAYING
	current_kills = 0
	current_time = 0.0
	current_level = 1
	
	# Unpause
	get_tree().paused = false
	
	# Reload the scene
	get_tree().reload_current_scene()

func pause_game() -> void:
	if current_state == GameState.PLAYING:
		current_state = GameState.PAUSED
		get_tree().paused = true

func resume_game() -> void:
	if current_state == GameState.PAUSED:
		current_state = GameState.PLAYING
		get_tree().paused = false

func load_high_scores() -> void:
	var err := config_file.load(save_path)
	
	if err == OK:
		high_score_kills = config_file.get_value("highscores", "kills", 0)
		high_score_time = config_file.get_value("highscores", "time", 0.0)
		high_score_level = config_file.get_value("highscores", "level", 1)
		print("Loaded high scores - Kills: ", high_score_kills, " Time: ", high_score_time, " Level: ", high_score_level)
	else:
		print("No high scores file found, starting fresh")

func save_high_scores() -> void:
	config_file.set_value("highscores", "kills", high_score_kills)
	config_file.set_value("highscores", "time", high_score_time)
	config_file.set_value("highscores", "level", high_score_level)
	
	var err := config_file.save(save_path)
	if err == OK:
		print("High scores saved successfully")
	else:
		print("Error saving high scores: ", err)

func get_high_scores() -> Dictionary:
	return {
		"kills": high_score_kills,
		"time": high_score_time,
		"level": high_score_level
	}
