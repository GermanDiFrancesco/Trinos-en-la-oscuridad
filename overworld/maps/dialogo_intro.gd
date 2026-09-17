extends Interactuable
var player
var speaker_name = 'NAOMI'
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("interaction") and not interacted:
		interacted = true
		player = area.find_parent("Player")
		if player:
			player.active = false
		
		var historia = [
			{
				"speaker": speaker_name,
				"text": "Qué sueño más extraño, tengo que dejar de mirar películas raras.",
				"options": [{"nombre": "Oh no!"}]
			},
			{
				"speaker": speaker_name,
				"text": "¡Me dormí!. . . ¡El concierto!",
				"options": [{"nombre": "¡Tengo que apurarme!"}]
			}
		]
		UIManager.dialog_panel.show_sequence(historia)
		await UIManager.dialog_panel.dialog_end
		player.active = true
		queue_free()
