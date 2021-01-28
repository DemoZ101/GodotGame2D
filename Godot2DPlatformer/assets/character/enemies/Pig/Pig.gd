extends KinematicBody2D

export (int) var speed 
export (int) var gravity

var velocity = Vector2()
var facing = 1
var is_dead = false
var is_angry = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("run")
	speed = -30
	gravity = 900
	is_dead=false
	is_angry = false
	

func _physics_process(delta):
	
	velocity.y += gravity * delta
	velocity.x = facing * speed
	velocity = move_and_slide(velocity, Vector2(0, -1))
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name == "Player":
			collision.collider.hurt()
		if collision.normal.x != 0:
			facing = sign(collision.normal.x)
			velocity.y = -100
			scale.x *= -1
	if position.y > 1000:
		queue_free()
	if $RayCast2D.is_colliding() == false:
			facing = facing * -1
			scale.x *= -1

func take_damage():
	is_dead = true
	$HitSound.play()
	$AnimationPlayer.play('death')
	$CollisionShape2D.disabled = true
	set_physics_process(false)




func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name =='death':
		queue_free()

