extends Area2D


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == 'getpoint':
		$AnimationPlayer.play("pointed")
