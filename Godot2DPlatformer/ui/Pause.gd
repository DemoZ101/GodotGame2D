extends CanvasLayer

func _ready():
	set_visible(false)

func _input(event):
	if event.is_action_pressed("pause"):
		set_visible(!get_tree().paused)
		get_tree().paused = !get_tree().paused

func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible

func _on_Resume_pressed():
	get_tree().paused = false
	set_visible(false)

func _on_Restart_pressed():
	get_tree().paused = false
	set_visible(false)
	GameState.restart()
