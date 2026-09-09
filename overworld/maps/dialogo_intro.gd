extends Interactuable
var player

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("interaction") and not interacted:
		interacted = true
		player = area.find_parent("Player")
		if player:
			player.active = false
		
		var historia = [
			{
				"speaker": "Prota",
				"text": "Qué sueño más extraño, tengo que dejar de mirar películas raras.",
				"options": [{"nombre": "Oh no"}]
			},
			{
				"speaker": "Prota",
				"text": "¡Me quedé dormido!. . . ¡El concierto!",
				"options": [{"nombre": "¡Tengo que apurarme!"}]
			}
		]
		UIManager.dialog_panel.show_sequence(historia)
		await UIManager.dialog_panel.dialog_end
		player.active = true
		queue_free()
