extends KinematicBody2D

onready var animation_player = $AnimationPlayer
onready var sprite = $AnimatedSprite
onready var timer = $ResetTimer

export var reset_time : float = 2.0

onready var reset_posision = global_position

var gravity = 750
var is_triggered = false
var velocity = Vector2()


func _ready():
	set_physics_process(false)

func _physics_process(delta):
	velocity.y += gravity * delta
	position += 1.3 * velocity * delta

func collide_with(collision : KinematicCollision2D, collider : KinematicBody2D):
	if !is_triggered:
		is_triggered = true
		sprite.stop()
		animation_player.play("Shake")
		velocity = Vector2.ZERO

func _on_AnimationPlayer_animation_finished(anim_name):
	set_physics_process(true)
	timer.start(reset_time)
 
func _on_ResetTimer_timeout():
	set_physics_process(false)
	yield(get_tree(), "physics_frame")
	var temp = collision_layer
	collision_layer = 0
	global_position = reset_posision
	yield(get_tree(), "physics_frame")
	collision_layer = temp
	is_triggered = false
	sprite.play("On")
