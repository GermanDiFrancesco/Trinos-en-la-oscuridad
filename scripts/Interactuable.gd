extends Area2D
class_name Interactuable
# Clase base para objetos interactuables
@export_group("DIALOGO")
@export var datos_dialogo: DialogueData #recurso
@export var speaker: String #recurso

func interact(_target):
	if not datos_dialogo:
		print("Falta el recurso de diálogo en este objeto interactuable")
		return
	procesar_dialogo()

func procesar_dialogo():
	var opciones_preparadas = []
	for opt in datos_dialogo.opciones:
		if opt:
			var id_actual = opt.evento_id
			opciones_preparadas.append({
				"nombre": opt.nombre,
				"callback": func(): _procesar_evento(id_actual)
			})
	UIManager.dialog_panel.show_dialog(speaker.capitalize(), datos_dialogo.texto_principal, opciones_preparadas)

func _procesar_evento(id: String):#esto se puede pasar al global, implementar  herrencia con las entidades
	match id:
		_:
			if id != "":
				print("Evento no reconocido: ", id)
