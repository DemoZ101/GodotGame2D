extends KinematicBody2D

var is_dead = false
var velocity = Vector2()
var speed 
var down = 160
var distance = 0
var fly = 30

onready var idle_time = $IdleTimer
onready var end_attack = $EndAttack
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")
	is_dead = false
	speed = 0
	idle_time.start()

func _physics_process(delta):
	velocity.y += speed * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name == "Player":
			collision.collider.hurt()
			end_attack.start()
		if collision.normal.y != 0:
			end_attack.start()
			print("colide")
	distance += velocity.y
	if distance < 0:
		idle_time.start()
		speed = 0
	print(distance)

func take_damage():
	is_dead = true
	$HitSound.play()
	$CollisionShape2D.disabled = true
	set_physics_process(false)
	$AnimationPlayer.play("death")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == 'death':
		queue_free()


func _on_IdleTimer_timeout():
	speed = down
	distance += velocity.y
	print("attack")
	$AnimationPlayer.play("Attack")


func _on_EndAttack_timeout(delta):
	if distance != 0:
		speed = fly
	$AnimationPlayer.play("Fly")
	print("flying")
		#print(distance)
