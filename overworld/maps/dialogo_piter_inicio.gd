extends RefCounted

func execute(npc_name: String, target: Node2D) -> void:
	target.active = false
	
	var secuencia = [
		{
			"speaker": npc_name,
			"text": "Hola, Soy piter, tal vez te acuerdes de mi del coro, el tema que tengo que contarte que afuera es un bardo.",
			"options": [{"nombre": "no me la contes"}]
		},
		{
			"speaker": npc_name,
			"text": "Parece que una niebla maligna se esta apoderando de las personas.",
			"options": [{"nombre": "Tenemos que hacer algo"}]
		}
	]
	
	UIManager.dialog_panel.show_sequence(secuencia)
	await UIManager.dialog_panel.dialog_end
	
	target.active = true
