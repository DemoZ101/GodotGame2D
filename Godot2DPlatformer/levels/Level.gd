extends Node2D

signal score_changed

var Collectible = preload('res://assets/items/Collectible.tscn')
var Danger_Down = preload('res://assets/items/SpikeDown.tscn')
var Danger_Left = preload('res://assets/items/SpikeLeft.tscn')
var Danger_Right = preload('res://assets/items/SpikeRight.tscn')
var Danger_Top = preload('res://assets/items/SpikeTop.tscn')
var Danger_Fall = preload('res://assets/items/SpikeFall.tscn')
var Water = preload('res://assets/items/Water.tscn')

onready var pickups = $Pickups
onready var dangers = $Danger
onready var HUD = $CanvasLayer/HUD
var player_life = 2
var score = 0

func _ready():
	$Player.connect('life_changed', $CanvasLayer/HUD, '_on_Player_life_changed')
	$Player.connect('dead', self, '_on_Player_dead')
	connect('score_changed', $CanvasLayer/HUD, '_on_score_changed')
	#score = 0
	emit_signal('score_changed', score)
	pickups.hide()
	dangers.hide()
	$Player.start($PlayerSpawn.position)
	#set_camera_limits()
	spawn_pickups()
	spawn_spikes()

func set_camera_limits():
	var map_size = $World.get_used_rect()
	var cell_size = $World.cell_size
	$Player/Camera2D.limit_left = (map_size.position.x - 5) * cell_size.x
	$Player/Camera2D.limit_right = (map_size.end.x + 5) * cell_size.x

func spawn_pickups():
	for cell in pickups.get_used_cells():
		var id = pickups.get_cellv(cell)
		var type = pickups.tile_set.tile_get_name(id)
		if type in ['apple', 'cherry', 'orange', 'pineapple', 'strawberry']:
			var c = Collectible.instance()
			var pos = pickups.map_to_world(cell)
			c.init(type, pos + pickups.cell_size/2)
			add_child(c)
			c.connect('pickup', self, '_on_Collectible_pickup')

func spawn_spikes():
	for cell in dangers.get_used_cells():
		var id = dangers.get_cellv(cell)
		var type = dangers.tile_set.tile_get_name(id)
		if type in ['Down', 'Left', 'Top', 'Right', 'Fall','water']:
			if type == 'Down':
				var d = Danger_Down.instance()
				var pos = dangers.map_to_world(cell)
				d.init(pos + dangers.cell_size/2)
				add_child(d)
			if type == 'Left':
				var d = Danger_Left.instance()
				var pos = dangers.map_to_world(cell)
				d.init(pos + dangers.cell_size/2)
				add_child(d)
			if type == 'Right':
				var d = Danger_Right.instance()
				var pos = dangers.map_to_world(cell)
				d.init(pos + dangers.cell_size/2)
				add_child(d)
			if type == 'Top':
				var d = Danger_Top.instance()
				var pos = dangers.map_to_world(cell)
				d.init(pos + dangers.cell_size/2)
				add_child(d)
			if type == 'Fall':
				var d = Danger_Fall.instance()
				var pos = dangers.map_to_world(cell)
				d.init(pos + dangers.cell_size/2)
				add_child(d)
			if type == 'water':
				var d = Water.instance()
				var pos = dangers.map_to_world(cell)
				d.init(pos + dangers.cell_size/2)
				add_child(d)

func _on_Collectible_pickup():
	$PickupSound.play()
	score += 100
	emit_signal('score_changed', score)

func _on_Player_dead():
	if player_life >=0:
		player_life -=1
		$Player.position = $PlayerSpawn.position
		$Player.life = 3
		print (player_life)
	else:
		GameState.restart()

func _on_Door_body_entered(body):
	if $PlayerSpawn.position != $Door.position:
		$PlayerSpawn.position = $Door.position
		$Door/AnimationPlayer.play("getpoint")
	


