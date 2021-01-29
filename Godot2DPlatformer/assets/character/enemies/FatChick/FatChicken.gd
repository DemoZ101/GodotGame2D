extends KinematicBody2D

var speed =100.0
var jump_speed = -260.0

var gravity = 750.0

var is_dead = false
var velocity = Vector2()
var facing = 1
var is_jumping = false
var is_idleing = false
var is_facing = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_dead = false
	speed = 0.0
	jump_speed = -260
	gravity = 750.0
	is_idleing = true

func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = facing * speed
	velocity = move_and_slide(velocity, Vector2(0, -1))
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name == "Player":
			collision.collider.hurt()
		if collision.normal.y != 0:
			if is_idleing == false:
				$AnimationPlayer.play("idle")
				is_idleing = true
	if is_dead == false:
		if velocity.y <0:
			$AnimationPlayer.play("jump")
		if velocity.y >0:
			$AnimationPlayer.play("Fall")
		if velocity.y == 0:
			if !$AnimationPlayer.is_playing():
				$AnimationPlayer.play("idle")
			print($AnimationPlayer.is_playing())



func take_damage():
	is_dead = true
	$HitSound.play()
	$AnimationPlayer.play('death')
	$CollisionShape2D.disabled = true
	set_physics_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name =='death':
		queue_free()
	if anim_name == 'idle':
		speed = 95
		velocity.y = jump_speed
	if anim_name == 'jump':
		is_idleing = false


func _on_AnimationPlayer_animation_started(anim_name: String) -> void:
	if anim_name == 'idle':
		speed = 0
		scale.x *= -1
		facing *=-1

