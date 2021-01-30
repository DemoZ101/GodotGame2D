extends KinematicBody2D

signal life_changed
signal dead

const UP = Vector2(0,-1)
const SLOPE_STOP = 64
const WALL_JUMP_VELOCITY = Vector2(-260, -260)

var velocity = Vector2()
var move_speed = 100.0
var gravity = 750.0
var jump_velocity = -260
var bounce_velocity = -400
var is_grounded = true
var is_jumping
var life
var move_direction
var air_jump = true
var wall_direction = 1
var last_record_direction = 1

onready var anim_player = $AnimationPlayer
onready var groundraycasts = $GroundRaycast
onready var justtakedamage_timer = $JusttakedamageTimer
onready var effect_animation = $EffectAnimation
onready var jumps = $JumpSound


func _physics_process(delta):
	_get_input()

func _apply_gravity(delta):
	velocity.y += gravity*delta
	#print(velocity.y)

func _cap_gravity_wall_slide():
	var max_velocity = 30
	velocity.y = min(velocity.y, max_velocity)

func _apply_movement():
	if is_jumping && velocity.y >= 0:
			is_jumping = false
	
	var snap = Vector2.DOWN * 4 if !is_jumping else Vector2.ZERO
	
	if move_direction == 0 && abs(velocity.x) < SLOPE_STOP:
		velocity.x = 0
	
	var stop_on_slope = true if get_floor_velocity().x == 0 else false
	velocity = move_and_slide_with_snap(velocity, snap, Vector2(0,-1), stop_on_slope)

	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.is_in_group('Danger'):
			hurt()
		if collision.collider.is_in_group("enemies"):
			var player_feet = (position + $CollisionShape2D.shape.extents).y
			if player_feet < collision.collider.position.y:
				collision.collider.take_damage()
				velocity.y = -200
				velocity.x = move_direction*-200
			else:
				hurt()
		if collision.collider.has_method("collide_with"):
			collision.collider.collide_with(collision, self)

func _update_move_diretion():
	move_direction = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	if move_direction != 0:
		last_record_direction = move_direction

func _get_input():
	_update_move_diretion()
	velocity.x = lerp(velocity.x, move_speed*move_direction, _get_h_weight())
	#print(velocity.x)
	if move_direction != 0:
		$Sprite.scale.x = move_direction
		$CollisionShape2D.scale.x = move_direction

func _get_h_weight():
	return 0.2 if is_grounded else 0.1

func wall_jump():
	var wall_jump_velocity = WALL_JUMP_VELOCITY
	wall_jump_velocity.x *= wall_direction
	velocity=wall_jump_velocity
	$JumpSound.play()

func _check_is_grounded():
	for raycast in groundraycasts.get_children():
		if raycast.is_colliding():
			return true
	return false

func _update_wall_direction():
	wall_direction = -int(next_to_left_wall())+int(next_to_right_wall())

func start(pos):
	position = pos
	show()
	life = 3
	emit_signal('life_changed', life)
	anim_player.play("idle")

func hurt():
	if justtakedamage_timer.is_stopped():
		justtakedamage_timer.start()
		effect_animation.play("flash")
		$HurtSound.play()
		$AnimationPlayer.play("hurt")
		velocity.x = -last_record_direction * 200
		velocity.y = -150
		#position.x += -last_record_direction * 20
		life -= 1
		emit_signal("life_changed",life)
		if life == 0:
			emit_signal("dead")
			emit_signal("life_changed",life)

func dead():
	emit_signal("dead")
	emit_signal("life_changed", life)

func bounce(BOUNCY = bounce_velocity):
	velocity.y = BOUNCY

func Float():
	pass

func next_to_wall():
	return next_to_left_wall() or next_to_right_wall()

func next_to_right_wall():
	return $RightWallRayCast1.is_colliding() or $RightWallRayCast2.is_colliding()

func next_to_left_wall():
	return $LeftWallRayCast1.is_colliding() or $LeftWallRayCast2.is_colliding()


func _on_JusttakedamageTimer_timeout() -> void:
	effect_animation.play("rest")
	$HurtSound.stop()
