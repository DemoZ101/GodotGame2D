extends Area2D

func init(pos):
	position = pos

func _on_SpikeDown_body_entered(body):
	if body.has_method("hurt"):
		body.hurt()
