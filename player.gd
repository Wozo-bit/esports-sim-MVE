extends Node
class_name MyPlayer

# Player properties
var player_name: String
var role: String
var max_health: int = 100
var current_health: int = 100
var attack_power: int = 20
var heal_power: int = 15

# Constructor
func _init(player_name_param: String, player_role: String) -> void:
	player_name = player_name_param
	role = player_role

# Check if alive
func is_alive() -> bool:
	return current_health > 0

# Take damage
func take_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)

# Heal
func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
