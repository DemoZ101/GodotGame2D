extends Area2D

func init(pos):
	position = pos

func _on_SpikeTop_body_entered(body: Node) -> void:
	if body.has_method("hurt"):
		body.hurt()
