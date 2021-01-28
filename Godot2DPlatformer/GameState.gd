extends Node

var num_levels = 5
var current_level = 1
var total_life = 2

var game_scene = 'res://Main.tscn'
var title_screen = 'res://ui/TitleScreen.tscn'

func restart():
	if total_life >0:
		get_tree().reload_current_scene()
		print(total_life)
	else:
		total_life=2
		get_tree().change_scene(title_screen)

func next_level():
	current_level += 1
	if current_level <= num_levels:
		get_tree().reload_current_scene()