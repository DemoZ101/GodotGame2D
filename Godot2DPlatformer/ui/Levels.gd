extends Node2D


func _on_Lvl1_body_entered(body: Node) -> void:
	if body.name == 'Player':
		GameState.current_level = 1
		get_tree().change_scene(GameState.game_scene)


func _on_Lvl2_body_entered(body: Node) -> void:
		if body.name == 'Player':
			GameState.current_level = 2
			get_tree().change_scene(GameState.game_scene)


func _on_Lvl3_body_entered(body: Node) -> void:
		if body.name == 'Player':
			GameState.current_level = 3
			get_tree().change_scene(GameState.game_scene)


func _on_Lvl4_body_entered(body: Node) -> void:
		if body.name == 'Player':
			GameState.current_level = 4
			get_tree().change_scene(GameState.game_scene)


func _on_Lvl5_body_entered(body: Node) -> void:
		if body.name == 'Player':
			GameState.current_level = 5
			get_tree().change_scene(GameState.game_scene)


func _on_Lvl6_body_entered(body: Node) -> void:
		if body.name == 'Player':
			GameState.current_level = 6
			get_tree().change_scene(GameState.game_scene)


func _on_Lvl7_body_entered(body: Node) -> void:
		if body.name == 'Player':
			GameState.current_level = 7
			get_tree().change_scene(GameState.game_scene)


func _on_Lvl8_body_entered(body: Node) -> void:
		if body.name == 'Player':
			GameState.current_level = 8
			get_tree().change_scene(GameState.game_scene)


func _on_Lvl9_body_entered(body: Node) -> void:
		if body.name == 'Player':
			GameState.current_level = 9
			get_tree().change_scene(GameState.game_scene)


func _on_Lvl10_body_entered(body: Node) -> void:
		if body.name == 'Player':
			GameState.current_level = 10
			get_tree().change_scene(GameState.game_scene)
