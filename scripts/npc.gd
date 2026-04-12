extends Area2D

@export_group("Configuración Visual")
enum Facing { DOWN, UP, LEFT, RIGHT }
@export var facing: Facing = Facing.DOWN
@export_enum("james", "daniel", "kruta") var npcSprite: String = ""

@export_group("DIALOGO")
@export var datos_dialogo: DialogueData # Aquí arrastras tu recurso .tres

@onready var sprite_sheet = $Spritesheet
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	setup_visuals()
func interact(_target):
	if not datos_dialogo:
		print("Falta el recurso de diálogo en este NPC")
		return
	var opciones_preparadas = []
	# Recorremos cada recurso DialogueOptionData en el array
	for opt in datos_dialogo.opciones:
		if opt: # Verificamos que no esté vacío el slot
			var id_actual = opt.evento_id
			opciones_preparadas.append({
				"nombre": opt.nombre,
				"callback": func(): _procesar_evento(id_actual)
			})
	
	# Enviamos al controlador de UI
	UIManager.dialog_panel.show_dialog(npcSprite.capitalize(),datos_dialogo.texto_principal, opciones_preparadas)

func _procesar_evento(id: String):#esto se puede pasar al global, implementar  herrencia con las entidades
	match id:
		"baritono_selected":
			Global.select_chord("baritono")
		"tenor_selected":
			Global.select_chord("tenor")
		"mezzo_selected":
			Global.select_chord("mezzo")
		"soprano_selected":
			Global.select_chord("soprano")
		"custom":
			UIManager.dialog_panel.show_dialog(npcSprite.capitalize(),'siguiente dialogo')
		_:
			if id != "":
				print("Evento no reconocido: ", id)

func setup_visuals():
	var path = "res://assets/overworld/pjs_spritesheet/" + npcSprite + "_walking.png"
	sprite_sheet.texture = load(path)
	
	var anims = { Facing.DOWN: "idle_down", Facing.UP: "idle_up", Facing.LEFT: "idle_left", Facing.RIGHT: "idle_right" }
	animation_player.play(anims[facing])
