extends Area2D

var velocity=Vector2()
var direction
export (int) var firing_speed=135
func set_direction(isleft):
	if isleft:
		direction=-1
		$Sprite.flip_h=true
	else:
		direction=1
		$Sprite.flip_h=false

func _physics_process(delta):
	velocity.x=firing_speed*delta*direction
	translate(velocity)
	pass

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == 'Player':
		body.hurt()
		queue_free()
	queue_free()
	
