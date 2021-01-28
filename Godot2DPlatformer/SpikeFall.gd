extends Area2D

var speed = 0
var fall_speed = 50

var velocity = Vector2()

func _ready() -> void:
	speed = 0

func _physics_process(delta):
	velocity.y += speed *delta
	position.y += velocity.y * delta

func init(pos):
	position = pos

func _on_SpikeFall_body_entered(body: Node) -> void:
	if body.has_method("hurt"):
		body.hurt()
		queue_free()
	print("hurt")

func _on_Area2D_body_entered(body: Node) -> void:
	if body.has_method("hurt"):
		speed = fall_speed
		print('detect player')
