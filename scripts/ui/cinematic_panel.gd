extends Control

func play(name):
	$AnimationPlayer.play(name)
	await $AnimationPlayer.animation_finished

	if name =="intro_flautista":
		Global.saved_data.cinematic_wached.intro=true

func _unhandled_input(event: InputEvent) -> void:
	$AnimationPlayer.emit_signal("animation_finished")
