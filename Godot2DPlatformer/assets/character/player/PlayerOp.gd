extends KinematicBody2D

signal life_changed
signal dead

const UP = Vector2(0,-1)
const SLOPE_STOP = 64

var velocity = Vector2()
var move_speed = 100.0
var gravity = 750.0
var jump_velocity = -260
var is_grounded
var life
var facing

onready var anim_player = $AnimationPlayer
onready var groundraycasts = $GroundRaycast
onready var justtakedamage_timer = $JusttakedamageTimer
onready var effect_animation = $EffectAnimation

func _physics_process(delta):
	_get_input()
	
func _apply_gravity(delta):
	velocity.y += gravity*delta
	
	
	velocity = move_and_slide(velocity,UP,SLOPE_STOP)
	
	is_grounded = _check_is_grounded()
	_assign_animation()
	scale.x = facing*0.8

func _input(event):
	if event.is_action_pressed("jump") && is_grounded:
		velocity.y = jump_velocity

func _get_input():
	var move_diretion = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	velocity.x = lerp(velocity.x, move_speed*move_diretion, _get_h_weight())
	if Input.is_action_pressed("ui_left"):
		facing=-1
	elif Input.is_action_pressed("ui_right"):
		facing=1
		

func _get_h_weight():
	return 0.2 if is_grounded else 0.1

func _check_is_grounded():
	for raycast in groundraycasts.get_children():
		if raycast.is_colliding():
			return true
		
	return false

func _assign_animation():
	var anim = 'idle'
	
	if !is_grounded:
		if velocity.y <0:
			anim ='jump_up'
		else:
			anim = 'jump_down'
	elif velocity.x!=0:
		anim = 'run'
	if anim_player.assigned_animation != anim:
		anim_player.play(anim)

func start(pos):
	position = pos
	show()
	life = 3
	emit_signal('life_changed', life)

func hurt():
	if justtakedamage_timer.is_stopped():
		justtakedamage_timer.start()
		effect_animation.play("flash")
		$HurtSound.play()


func next_to_wall():
	return next_to_left_wall() or next_to_right_wall()

func next_to_right_wall():
	return $RightWallRayCast1.is_colliding() or $RightWallRayCast2.is_colliding()

func next_to_left_wall():
	return $LeftWallRayCast1.is_colliding() or $LeftWallRayCast2.is_colliding()


func _on_JusttakedamageTimer_timeout() -> void:
	effect_animation.play("rest")
