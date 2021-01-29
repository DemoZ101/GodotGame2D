extends Area2D


func init(pos):
	position = pos
	$AnimationPlayer.play("idle")

func _on_Water_body_entered(body: Node) -> void:
	if body.has_method("hurt"):
		GameState.restart()
