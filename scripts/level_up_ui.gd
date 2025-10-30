extends CanvasLayer

signal upgrade_selected

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/VBoxContainer/TitleLabel
@onready var upgrade_container: HBoxContainer = $Panel/VBoxContainer/UpgradeContainer

var upgrade_button_scene: PackedScene = preload("res://scenes/upgrade_button.tscn")
var current_upgrades: Array = []
var player: Node = null

func _ready() -> void:
	# Hide by default
	visible = false
	
	# Find player
	call_deferred("find_player")

func find_player() -> void:
	var root := get_tree().root
	player = root.find_child("Player", true, false)
	
	if player and player.has_signal("level_up"):
		player.level_up.connect(_on_player_level_up)

func _on_player_level_up() -> void:
	show_upgrade_choices()

func show_upgrade_choices() -> void:
	# Clear previous upgrade buttons
	for child in upgrade_container.get_children():
		child.queue_free()
	
	# Get random upgrades from manager
	current_upgrades = UpgradeManager.get_random_upgrades(3)
	
	# Create button for each upgrade
	for upgrade in current_upgrades:
		var button := create_upgrade_button(upgrade)
		upgrade_container.add_child(button)
	
	# Show the UI with animation
	visible = true
	animate_show()

func create_upgrade_button(upgrade) -> Button:
	var button := Button.new()
	button.custom_minimum_size = Vector2(200, 150)
	
	# Create vertical layout for button content
	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	button.add_child(vbox)
	
	# Upgrade name
	var name_label := Label.new()
	name_label.text = upgrade.name
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(name_label)
	
	# Level indicator
	var level_label := Label.new()
	level_label.text = "Level %d → %d" % [upgrade.current_level, upgrade.current_level + 1]
	level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_label.add_theme_font_size_override("font_size", 14)
	level_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	vbox.add_child(level_label)
	
	# Description
	var desc_label := Label.new()
	desc_label.text = upgrade.description
	desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.add_theme_font_size_override("font_size", 14)
	vbox.add_child(desc_label)
	
	# Connect button press
	button.pressed.connect(_on_upgrade_selected.bind(upgrade))
	
	return button

func _on_upgrade_selected(upgrade) -> void:
	# Apply the upgrade
	if player:
		UpgradeManager.apply_upgrade(upgrade, player)
	
	# Hide UI
	animate_hide()
	
	# Resume game after animation
	await get_tree().create_timer(0.3).timeout
	get_tree().paused = false

func animate_show() -> void:
	panel.modulate.a = 0
	panel.scale = Vector2(0.8, 0.8)
	
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate:a", 1.0, 0.3)
	tween.tween_property(panel, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func animate_hide() -> void:
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(panel, "modulate:a", 0.0, 0.2)
	tween.tween_property(panel, "scale", Vector2(0.9, 0.9), 0.2)
	tween.tween_callback(func(): visible = false)
