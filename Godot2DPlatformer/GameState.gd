extends Node

var num_levels = 10
var current_level = 1
var total_life = 2

var game_scene = 'res://Main.tscn'
var main_menu = 'res://ui/MainMenu.tscn'
var levels_menu = 'res://ui/Levels.tscn'

func restart():
	get_tree().reload_current_scene()

func next_level():
	current_level += 1
	if current_level <= num_levels:
		get_tree().reload_current_scene()
