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
			Global.saved_data.select_cuerda("baritono")
		"tenor_selected":
			Global.saved_data.select_cuerda("tenor")
		"mezzo_selected":
			Global.saved_data.select_cuerda("mezzo")
		"soprano_selected":
			Global.saved_data.select_cuerda("soprano")
		"battle":
			Global.change_state("BATTLE")
		"custom":
			UIManager.dialog_panel.show_dialog(npcSprite.capitalize(),'siguiente dialogo')
		_:
			if id != "":
				print("Evento no reconocido: ", id)
func face_direction(target_position: Vector2) -> void:
	var direction = target_position - global_position
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			facing = Facing.RIGHT
		else:
			facing = Facing.LEFT
	else:
		# Es vertical
		if direction.y > 0:
			facing = Facing.DOWN
		else:
			facing = Facing.UP
	_update_animation()

func _update_animation() -> void:
	var anims = { 
		Facing.DOWN: "idle_down", 
		Facing.UP: "idle_up", 
		Facing.LEFT: "idle_left", 
		Facing.RIGHT: "idle_right" 
	}
	if animation_player.has_animation(anims[facing]):
		animation_player.play(anims[facing])
func setup_visuals():
	var path = "res://assets/pjs_spritesheet/" + npcSprite + "_walking.png"
	sprite_sheet.texture = load(path)
	_update_animation()
