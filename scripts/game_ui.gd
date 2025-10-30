extends CanvasLayer

@onready var health_bar: ProgressBar = $Container/HBoxContainer/HealthBox/HealthBar
@onready var health_numbers: Label = $Container/HBoxContainer/HealthBox/HealthNumbers
@onready var kills_label: Label = $Container/HBoxContainer/StatsBox/KillsLabel
@onready var time_label: Label = $Container/HBoxContainer/StatsBox/TimeLabel

var kill_count: int = 0
var time_elapsed: float = 0.0

func _ready() -> void:
	# Initialize UI
	update_kills(0)
	update_time(0.0)

func _process(delta: float) -> void:
	# Update time counter
	time_elapsed += delta
	update_time(time_elapsed)

func update_health(current: int, maximum: int) -> void:
	if health_bar and health_numbers:
		health_bar.max_value = maximum
		health_bar.value = current
		health_numbers.text = "%d/%d" % [current, maximum]

func update_kills(count: int) -> void:
	kill_count = count
	if kills_label:
		kills_label.text = "Kills: %d" % kill_count

func increment_kills() -> void:
	update_kills(kill_count + 1)

func update_time(seconds: float) -> void:
	if time_label:
		var minutes: int = int(seconds) / 60
		var secs: int = int(seconds) % 60
		time_label.text = "Time: %02d:%02d" % [minutes, secs]

