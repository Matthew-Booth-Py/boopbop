extends CanvasLayer

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/VBoxContainer/TitleLabel
@onready var stats_container: VBoxContainer = $Panel/VBoxContainer/StatsContainer
@onready var kills_label: Label = $Panel/VBoxContainer/StatsContainer/KillsLabel
@onready var time_label: Label = $Panel/VBoxContainer/StatsContainer/TimeLabel
@onready var level_label: Label = $Panel/VBoxContainer/StatsContainer/LevelLabel
@onready var high_scores_label: Label = $Panel/VBoxContainer/HighScoresLabel
@onready var restart_button: Button = $Panel/VBoxContainer/ButtonContainer/RestartButton
@onready var quit_button: Button = $Panel/VBoxContainer/ButtonContainer/QuitButton

func _ready() -> void:
	# Hide by default
	visible = false
	
	# Connect buttons
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)

func show_game_over(kills: int, time: float, level: int) -> void:
	# Update stats
	if kills_label:
		kills_label.text = "Kills: %d" % kills
	
	if time_label:
		var minutes: int = int(time) / 60
		var seconds: int = int(time) % 60
		time_label.text = "Time Survived: %02d:%02d" % [minutes, seconds]
	
	if level_label:
		level_label.text = "Level Reached: %d" % level
	
	# Show high scores
	var high_scores := GameManager.get_high_scores()
	if high_scores_label:
		var hs_minutes: int = int(high_scores.time) / 60
		var hs_seconds: int = int(high_scores.time) % 60
		high_scores_label.text = "High Scores - Kills: %d | Time: %02d:%02d | Level: %d" % [
			high_scores.kills,
			hs_minutes,
			hs_seconds,
			high_scores.level
		]
	
	# Show UI with animation
	visible = true
	animate_show()

func animate_show() -> void:
	panel.modulate.a = 0
	panel.scale = Vector2(0.8, 0.8)
	
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate:a", 1.0, 0.5)
	tween.tween_property(panel, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_restart_pressed() -> void:
	GameManager.restart_game()

func _on_quit_pressed() -> void:
	get_tree().quit()

