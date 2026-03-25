extends Node

var battle_controller: BattleController

func _ready() -> void:
	# Initialize BattleController
	battle_controller = BattleController.new()
	add_child(battle_controller)

	# Generate teams
	battle_controller.generate_teams()

	# Run the battle
	var winner: String = battle_controller.run_battle()
	print("\nFinal Winner:", winner)
