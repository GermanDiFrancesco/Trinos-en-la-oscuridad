extends RefCounted
func execute(npc_name: String, target: Node2D) -> void:
	target.active = false
	
	var secuencia = [
		{
			"speaker": npc_name,
			"text": "Hola, Soy " +str(npc_name)+", tal vez me recuerdes del coro.",
			"options": [{"nombre": "Ey que tal!"}]
		},
		{
			"speaker": npc_name,
			"text": "Parece que una niebla maligna se esta apoderando de las personas..",
			"options": [{"nombre": "Tenemos que hacer algo"}]
		}
	]
	
	UIManager.dialog_panel.show_sequence(secuencia)
	await UIManager.dialog_panel.dialog_end
	target.active = true

func _mostrar_segundo_dialogo(npc_name: String) -> void:
	UIManager.dialog_panel.show_dialog(
		npc_name,
		"Parece que una niebla maligna se esta apoderando de las personas.",
		[
			{
				"nombre": "Tenemos que hacer algo",
				"callback": func():
					UIManager.dialog_panel._end_dialog()
}
		]
	)
