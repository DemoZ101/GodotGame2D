extends Area2D

signal pickup

var textures = {'apple': 'res://assets/items/Collect/Apple.png',
				'cherry': 'res://assets/items/Collect/Cherry.png',
				'orange': 'res://assets/items/Collect/Orange.png',
				'pineapple': 'res://assets/items/Collect/Pineapple.png',
				'strawberry': 'res://assets/items/Collect/Strawberry.png'}

func init(type, pos):
	$Sprite.texture = load(textures[type])
	position = pos

func _on_Collectible_body_entered(body):
	emit_signal('pickup')
	$AnimationPlayer.play("picked")
	$CollisionShape2D.disabled


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == 'picked':
		queue_free()

