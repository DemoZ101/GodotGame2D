extends KinematicBody2D

onready var sprite = $AnimatedSprite

func _ready():
	sprite.play("default")

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body.has_method("hurt"):
			body.hurt()

func _on_Area2D_body_entered(body):
	if body.has_method("hurt"):
		body.hurt()
		
