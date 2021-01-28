extends KinematicBody2D
onready var sprite = $AnimatedSprite

func collide_with(collision : KinematicCollision2D, collider : KinematicBody2D):
		if collider.has_method("bounce"):
			collider.bounce()
			sprite.play("Bounch")


func _on_AnimatedSprite_animation_finished():
	sprite.play("Idle")
