extends KinematicBody2D

export (int) var gravity

var velocity = Vector2()

onready var WaitingATimer = $WaitingAttackTimer
onready var AtkTimer = $AttackTimer
onready var AtkCD = $AttackCoolDown
var player_in_range 
var is_dead = false

func _ready():
	$AnimationPlayer.play("Run")
	get_node("Area2D/CollisionShape2D").disabled = true
	player_in_range = false
	is_dead = false

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	velocity.y +=gravity * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	for idx in range(get_slide_count()):
		var collision = get_slide_collision(idx)
		if collision.collider.name == "Player":
			collision.collider.hurt()
	


func take_damage():
	is_dead = true
	$HitSound.play()
	$CollisionShape2D.disabled = true
	set_physics_process(false)
	$AnimationPlayer.play("death")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'Attack':
		$AnimationPlayer.play("Run")
		AtkCD.start()
	if anim_name == 'death':
		queue_free()

func Attack():
	if is_dead == false:
		if WaitingATimer.is_stopped():
			WaitingATimer.start()
			$AnimationPlayer.play("Attack")

func _on_StartAttackRange_body_entered(body: Node) -> void:
	if body.name == 'Player':
			player_in_range = true
			Attack()


func _on_WaitingAttackTimer_timeout() -> void:
	AtkTimer.start()
	get_node("Area2D/CollisionShape2D").disabled = false


func _on_AttackTimer_timeout() -> void:
	get_node("Area2D/CollisionShape2D").disabled =true


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name =='Player':
		body.hurt()


func _on_AttackCoolDown_timeout() -> void:
	if player_in_range == true:
		Attack()


func _on_StartAttackRange_body_exited(body: Node) -> void:
	if body.name == 'Player':
			player_in_range = false


func _on_HitSound_finished() -> void:
	$HitSound.stop()
