extends Node
class_name BattleController

@export var ROLES: Array = ["Top", "Jungle", "Mid", "ADC", "Support"]

var team1: Array[MyPlayer] = []
var team2: Array[MyPlayer] = []

# -------------------------
# PLAYER CREATION
# -------------------------
func _create_random_player(player_role: String) -> MyPlayer:
	var first_names = ["Alex", "Drew", "Casey", "Finn", "Harper", "Gale"]
	var last_names = ["Frost", "Wolf", "Drake", "Skye", "Shadow", "Blaze", "Raven"]
	var full_name = first_names[randi() % first_names.size()] + " " + last_names[randi() % last_names.size()]
	var player = MyPlayer.new(full_name, player_role)
	# Randomize stats slightly
	player.max_health = 80 + randi() % 41 # 80-120
	player.current_health = player.max_health
	player.attack_power = 15 + randi() % 11 # 15-25
	player.heal_power = 10 + randi() % 11 # 10-20
	return player

func generate_teams() -> void:
	team1.clear()
	team2.clear()
	for role in ROLES:
		team1.append(_create_random_player(role))
		team2.append(_create_random_player(role))
	print("Teams Generated!")
	for p in team1:
		print("Team1:", p.player_name, "(", p.role, ") HP:", p.max_health, "ATK:", p.attack_power, "HEAL:", p.heal_power)
	for p in team2:
		print("Team2:", p.player_name, "(", p.role, ") HP:", p.max_health, "ATK:", p.attack_power, "HEAL:", p.heal_power)

# -------------------------
# HELPER FUNCTIONS
# -------------------------
func _compare_health_lowest(a: MyPlayer, b: MyPlayer) -> int:
	return a.current_health - b.current_health

func choose_enemy_to_attack(attacker: MyPlayer) -> MyPlayer:
	var enemies = team2 if attacker in team1 else team1
	var alive_enemies: Array[MyPlayer] = []
	for e in enemies:
		if e.is_alive():
			alive_enemies.append(e)
	if alive_enemies.is_empty():
		return null
	alive_enemies.sort_custom(Callable(self, "_compare_health_lowest"))
	return alive_enemies[0]

func choose_ally_to_heal(support: MyPlayer) -> MyPlayer:
	var allies = team1 if support in team1 else team2
	var injured_allies: Array[MyPlayer] = []
	for a in allies:
		if a.is_alive() and a.current_health < a.max_health:
			injured_allies.append(a)
	if injured_allies.is_empty():
		return null
	injured_allies.sort_custom(Callable(self, "_compare_health_lowest"))
	return injured_allies[0]

# -------------------------
# RUN BATTLE
# -------------------------
func run_battle() -> String:
	var round_num = 1
	while true:
		print("\n-- Round %d --" % round_num)
		var all_players: Array[MyPlayer] = team1 + team2
		for p in all_players:
			if not p.is_alive():
				continue

			if p.role == "Support":
				var ally = choose_ally_to_heal(p)
				if ally != null:
					var heal_amount = p.heal_power + randi() % 6 # random +0-5
					ally.heal(heal_amount)
					print("%s heals %s for %d. %s HP: %d" % [p.player_name, ally.player_name, heal_amount, ally.player_name, ally.current_health])
				else:
					var enemy = choose_enemy_to_attack(p)
					if enemy != null:
						var dmg = p.attack_power + randi() % 6 # random +0-5
						enemy.take_damage(dmg)
						print("%s attacks %s for %d damage. %s HP: %d" % [p.player_name, enemy.player_name, dmg, enemy.player_name, enemy.current_health])
			else:
				var target = choose_enemy_to_attack(p)
				if target != null:
					var dmg = p.attack_power + randi() % 6 # random +0-5
					target.take_damage(dmg)
					print("%s attacks %s for %d damage. %s HP: %d" % [p.player_name, target.player_name, dmg, target.player_name, target.current_health])

		# Check for victory
		var team1_alive: Array[MyPlayer] = []
		for p in team1:
			if p.is_alive():
				team1_alive.append(p)
		var team2_alive: Array[MyPlayer] = []
		for p in team2:
			if p.is_alive():
				team2_alive.append(p)

		if team1_alive.is_empty():
			print("\nTeam 2 Wins!")
			return "Team 2"
		elif team2_alive.is_empty():
			print("\nTeam 1 Wins!")
			return "Team 1"

		round_num += 1

	# Safety fallback
	return "No Winner"
