extends Node2D


func _on_Play_body_entered(body: Node) -> void:
	if body.name == 'Player':
		get_tree().change_scene(GameState.game_scene)


func _on_ChooseLvl_body_entered(body: Node) -> void:
	if body.name == 'Player':
		get_tree().change_scene(GameState.levels_menu)
