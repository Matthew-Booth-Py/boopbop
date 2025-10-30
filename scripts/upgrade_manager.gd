extends Node

# Upgrade definitions
class Upgrade:
	var id: String
	var name: String
	var description: String
	var type: String  # "damage", "attack_speed", "speed", "max_health", "health_regen", "pickup_range"
	var value: float
	var max_level: int
	var current_level: int = 0
	
	func _init(p_id: String, p_name: String, p_desc: String, p_type: String, p_value: float, p_max_level: int = 5) -> void:
		id = p_id
		name = p_name
		description = p_desc
		type = p_type
		value = p_value
		max_level = p_max_level

# Available upgrades
var all_upgrades: Array[Upgrade] = []
var active_upgrades: Dictionary = {}  # id -> Upgrade

func _ready() -> void:
	initialize_upgrades()

func initialize_upgrades() -> void:
	all_upgrades = [
		# Weapon upgrades
		Upgrade.new(
			"axe_damage",
			"Sharper Axe",
			"Increase axe damage by 5",
			"damage",
			5.0,
			10
		),
		Upgrade.new(
			"attack_speed",
			"Swift Strikes",
			"Reduce attack cooldown by 0.1s",
			"attack_speed",
			0.1,
			7
		),
		
		# Movement upgrades
		Upgrade.new(
			"move_speed",
			"Fleet Footed",
			"Increase movement speed by 0.5",
			"speed",
			0.5,
			8
		),
		
		# Health upgrades
		Upgrade.new(
			"max_health",
			"Tough Skin",
			"Increase max health by 20",
			"max_health",
			20.0,
			10
		),
		Upgrade.new(
			"health_regen",
			"Regeneration",
			"Slowly regenerate health over time",
			"health_regen",
			1.0,
			5
		),
		
		# Utility upgrades
		Upgrade.new(
			"pickup_range",
			"Magnetism",
			"Increase XP pickup range by 1",
			"pickup_range",
			1.0,
			5
		),
	]
	
	# Initialize active upgrades dictionary
	for upgrade in all_upgrades:
		active_upgrades[upgrade.id] = upgrade

func get_random_upgrades(count: int = 3) -> Array[Upgrade]:
	var available: Array[Upgrade] = []
	
	# Filter upgrades that haven't reached max level
	for upgrade in all_upgrades:
		if upgrade.current_level < upgrade.max_level:
			available.append(upgrade)
	
	# If we don't have enough available upgrades, return what we have
	if available.size() <= count:
		return available
	
	# Randomly select upgrades
	var selected: Array[Upgrade] = []
	var available_copy := available.duplicate()
	
	for i in range(count):
		if available_copy.is_empty():
			break
		var random_index := randi() % available_copy.size()
		selected.append(available_copy[random_index])
		available_copy.remove_at(random_index)
	
	return selected

func apply_upgrade(upgrade: Upgrade, player: Node) -> void:
	if not player:
		return
	
	# Increment level
	upgrade.current_level += 1
	
	# Apply the upgrade to the player
	if player.has_method("apply_upgrade"):
		player.apply_upgrade(upgrade.type, upgrade.value)
	
	print("Applied upgrade: ", upgrade.name, " (Level ", upgrade.current_level, ")")

func get_upgrade_by_id(upgrade_id: String) -> Upgrade:
	if active_upgrades.has(upgrade_id):
		return active_upgrades[upgrade_id]
	return null

func reset_upgrades() -> void:
	# Reset all upgrade levels (for new game)
	for upgrade in all_upgrades:
		upgrade.current_level = 0

