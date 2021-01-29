extends KinematicBody2D

export (int) var speed 
export (int) var gravity

const bullet = preload("res://assets/character/enemies/Trunk/TrunkBulet.tscn")

onready var WaitAttack = $WaitingAttack
onready var EndAttack = $EndingAttack
onready var AtkCD = $AttackCD

var player_in_range = false
var canshoot = true
var velocity = Vector2()
var facing = 1
var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("Run")
	speed = -30
	gravity = 900
	is_dead=false
	canshoot = true

func _physics_process(delta):
	
	velocity.y += gravity * delta
	velocity.x = facing * speed
	#print (velocity.y)
	if player_in_range:
		velocity.x = 0
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
	var is_facing = facing
	if $Sprite.frame == 20:
		canshoot = true
	if $Sprite.frame == 21 && canshoot == true:
		var shoot_bullet = bullet.instance()
		if facing == 1:
			shoot_bullet.set_direction(true)
		else:
			shoot_bullet.set_direction(false)
		shoot_bullet.position = $Position2D.global_position
		get_parent().add_child(shoot_bullet)
		canshoot = false
		print (canshoot)

func take_damage():
	is_dead = true
	$HitSound.play()
	$AnimationPlayer.play('death')
	$CollisionShape2D.disabled = true
	set_physics_process(false)

func Shoot():
	if is_dead == false:
		if WaitAttack.is_stopped():
			AtkCD.start()
			$AnimationPlayer.play("Attack")


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == 'Player':
		player_in_range = true
		Shoot()
	


func _on_WaitingAttack_timeout() -> void:
	#var shoot_bullet = bullet.instance()
	#if facing == 1:
	#	shoot_bullet.set_direction(true)
	#else:
	#	shoot_bullet.set_direction(false)
	#shoot_bullet.position = $Position2D.global_position
	#get_parent().add_child(shoot_bullet)
	pass


func _on_AttackCD_timeout() -> void:
	pass


func _on_EndingAttack_timeout() -> void:
	pass
	


func _on_Area2D_body_exited(body: Node) -> void:
	if body.name == 'Player':
		player_in_range = false
		$AnimationPlayer.play("Run")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == 'Attack':
		if player_in_range == true:
			Shoot()
		else:
			$AnimationPlayer.play("Run")
	if anim_name =='death':
		queue_free()
