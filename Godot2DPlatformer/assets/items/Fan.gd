extends Node2D

onready var sprite = $AnimatedSprite
var max_velocity = -300

var turning_on = true

onready var node = get_node(".")

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body.has_method("Float"):
			if body.velocity.y > max_velocity:
				body.velocity.y -= 400*2 * delta

func _on_Area2D_body_entered(body):
	if body.has_method("Float"):
		body.velocity.y = -250
