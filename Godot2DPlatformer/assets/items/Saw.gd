extends Node2D

onready var sprite = $AnimatedSprite

func _ready():
	sprite.play("default")


func _physics_process(delta):
	for body in $AnimatedSprite/Area2D.get_overlapping_bodies():
		if body.has_method("hurt"):
			body.hurt()

