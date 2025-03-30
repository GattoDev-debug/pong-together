extends AnimationPlayer


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "new_animation":
		play("new_animation_2")
