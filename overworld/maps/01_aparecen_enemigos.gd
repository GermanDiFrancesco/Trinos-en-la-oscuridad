extends Interactuable

@export_category("Cinemática")
@export var focus_target: Node2D 
@export var pan_duration: float = 3.0 

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("interaction"):
		var player = area.find_parent("Player")
		if not player:
			return
		player.active = false
		var camera = player.get_node_or_null("OverworldCamera") as Camera2D
		var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		var target_offset = focus_target.global_position - player.global_position

		# Movemos la cámara
		tween.tween_property(camera, "offset", target_offset, pan_duration)
		await tween.finished
		UIManager.dialog_panel.show_dialog("Prota", "OH NO ahi vienen más..")
		await UIManager.dialog_panel.dialog_end
		var return_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		return_tween.tween_property(camera, "offset", Vector2.ZERO, 2.0)
		await return_tween.finished

		if is_instance_valid(player):
			player.active = true
		self.queue_free()
