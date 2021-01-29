extends "res://StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("wall_slide")
	call_deferred("set_state", states.idle)

func _input(event):
	if [states.idle, states.run].has(state):
		if event.is_action_pressed("jump") && parent._check_is_grounded():
			parent.velocity.y = parent.jump_velocity
			parent.is_jumping = true
			parent.air_jump = true
			parent.jumps.play()
	elif state == states.wall_slide:
		if event.is_action_pressed("jump"):
			parent.wall_jump()
			set_state(states.jump)
			parent.jumps.play()

func _state_logic(delta):
	parent._update_move_diretion()
	parent._update_wall_direction()
	if state!= states.wall_slide:
		parent._get_input()
	parent._apply_gravity(delta)
	if state == states.wall_slide:
		parent._cap_gravity_wall_slide()
	parent._apply_movement()
func _get_transition(delta):
	match state:
		states.idle:
			if !parent._check_is_grounded():
				if parent.velocity.y<0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x !=0:
				return states.run
		
		states.run:
			if !parent._check_is_grounded():
				if parent.velocity.y<0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.velocity.x ==0:
				return states.idle
		
		states.jump:
			if parent.wall_direction != 0:
				return states.wall_slide
			elif parent._check_is_grounded():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		
		states.fall:
			if parent.wall_direction != 0:
				return states.wall_slide
			elif parent._check_is_grounded():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
		
		states.wall_slide:
			if parent._check_is_grounded():
				return states.idle
			elif parent.wall_direction == 0:
				return states.fall
				
	return null
	print(states)

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("idle")
		states.run:
			parent.anim_player.play("run")
		states.jump:
			parent.anim_player.play("jump")
		states.fall:
			parent.anim_player.play("fall")
		states.wall_slide:
			parent.anim_player.play("wall_slide")

func _exit_state(new_state, old_state):
	pass
