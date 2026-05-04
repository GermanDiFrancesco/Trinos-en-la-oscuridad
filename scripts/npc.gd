extends Interactuable

@export_group("Configuración Visual")
enum Facing { DOWN, UP, LEFT, RIGHT }
@export var facing: Facing = Facing.DOWN
@export_enum("james", "daniel", "kruta","piter") var npcSprite: String = ""

@export_group("DIALOGO")

@onready var sprite_sheet = $Spritesheet
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	setup_visuals()

func procesar_dialogo():
	var opciones_preparadas = []
	for opt in datos_dialogo.opciones:
		if opt:
			var id_actual = opt.evento_id
			opciones_preparadas.append({
				"nombre": opt.nombre,
				"callback": func(): _procesar_evento(id_actual)
			})
	UIManager.dialog_panel.show_dialog(npcSprite.capitalize(), datos_dialogo.texto_principal, opciones_preparadas)

func _procesar_evento(id: String):#esto se puede pasar al global, implementar  herrencia con las entidades
	match id:
		"baritono_selected":
			Global.saved_data.select_chord("baritono")
		"tenor_selected":
			Global.saved_data.select_chord("tenor")
		"mezzo_selected":
			Global.saved_data.select_chord("mezzo")
		"soprano_selected":
			Global.saved_data.select_chord("soprano")
		"battle":
			Global.change_state("BATTLE")
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
