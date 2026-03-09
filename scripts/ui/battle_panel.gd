extends Panel
class_name BattleController

@onready var party_container: HBoxContainer = $DialogBox/PartyContainer
@onready var enemies_container: HBoxContainer = $EnemiesContainer

@onready var actions_container: VBoxContainer = $FondoDelMenu/ActionsContainer
#remplazar por show options
@onready var atacar_btn: TextureButton = $FondoDelMenu/ActionsContainer/AtacarBtn
@onready var cantar_btn: TextureButton = $FondoDelMenu/ActionsContainer/CantarBtn
@onready var usar_btn: TextureButton = $FondoDelMenu/ActionsContainer/UsarBtn
@onready var hablar_btn: TextureButton = $FondoDelMenu/ActionsContainer/HablarBtn
@onready var correr_btn: TextureButton = $FondoDelMenu/ActionsContainer/CorrerBtn

@onready var text_container: RichTextLabel = $DialogBox/MarginContainer/TextContainer
@onready var action_options_container: HBoxContainer = $DialogBox/ActionOptionsContainer

#aca se cargan los recursos enemy_data
@export var enemies: Array[EnemyData] = []
var enemy_units: Array[Combatant] = []
@export var combatant_scene: PackedScene


func init() -> void:
	visible = true
	atacar_btn.grab_focus()

func start_battle() -> void:
	enemy_units.clear()
	for child in enemies_container.get_children():
		child.queue_free()

	for e in enemies:
		print(e.display_name)
		var unit := Combatant.new(e)
		enemy_units.append(unit)

		var combatant_panel := combatant_scene.instantiate()
		enemies_container.add_child(combatant_panel)
		combatant_panel.setup(unit)

func display_text(text: String) -> void:
	for child in action_options_container.get_children():
		child.queue_free()
	text_container.text = text

#FOCUS action descriptions
func _on_atacar_btn_focus_entered() -> void:
	display_text("Ataca al enemigo cuerpo a cuerpo")
func _on_cantar_btn_focus_entered() -> void:
	display_text("Canta para distraer al enemigo y reducir su ataque")
func _on_usar_btn_focus_entered() -> void:
	display_text("Usa un objeto del inventario para ayudarte en la batalla")
func _on_hablar_btn_focus_entered() -> void:
	display_text("Habla con el enemigo para intentar persuadirlo o distraerlo")
func _on_correr_btn_focus_entered() -> void:
	display_text("Intenta escapar de la batalla")

func _on_atacar_btn_pressed() -> void:
	var enemy_options: Array = []
	for i in range(enemy_units.size()):
		enemy_options.append({
			"nombre": enemy_units[i].data.display_name,
			"funcion": "_on_enemy_selected",
			"enemy_index": i
		})
	show_options("Selecciona al oponente:", enemy_options)

func _on_enemy_selected(enemy_index: int) -> void:
	var part_options: Array = []
	var selected_enemy = enemy_units[enemy_index]
	for part in selected_enemy.data.parts:
		part_options.append({
			"nombre": part.display_name,
			"funcion": "_attack_part",
			"enemy_index": enemy_index,
			"part": part
		})
	show_options(
		"Selecciona la parte a atacar:",
		part_options
	)

func _attack_part(enemy_index: int, part) -> void:
	display_text("¡Atacas la parte " + part.display_name + " de " + enemy_units[enemy_index].data.display_name + "!")
	await get_tree().create_timer(1.5).timeout
	init()

func _on_cantar_btn_pressed() -> void:
	show_options()
func _on_usar_btn_pressed() -> void:
	show_options()
func _on_hablar_btn_pressed() -> void:
	show_options()
func _on_correr_btn_pressed() -> void:
	show_options(	
		"Quieres intentar escapar de la batalla?",
		[{
			"nombre": "Correr",
			"funcion": "_battle_escape",
			"descripcion": "Intentar escapar de la batalla"
		},
		{
			"nombre": "Seguir luchando",
			"funcion": "init",
			"descripcion": "Seguir luchando"
		}]
	)

func _battle_escape() -> void:
	display_text("Intentas escapar de la batalla...")
	Global.changeState("OVERWORLD")

func _on_enemy_focus(enemy_index: int) -> void:
	# Show information about the focused option
	if enemy_index < enemy_units.size():
		enemy_units[enemy_index].indicator()

#Recibe un texto general y una lista de opciones, cada opción es un diccionario con nombre, funcion y descripcion
func show_options(general_text: String = "", options: Array = []) -> void:
	#default config
	for child in action_options_container.get_children():
		child.queue_free()
	if options.is_empty():
		general_text = "No hay opciones disponibles"
	display_text(general_text)
	options.append({
		"nombre": "Cancelar",
		"funcion": "init",
		"descripcion": "cancelar"
	})
	#carga de opciones
	for option in options:
		var btn := Button.new()
		btn.text = option["nombre"]
		btn.focus_mode = Control.FOCUS_ALL
		# Crea un callable con parámetros si existen
		if option.has("enemy_index") and option.has("part"):
			btn.pressed.connect(Callable(self, option["funcion"]).bind(option["enemy_index"], option["part"]))
			btn.focus_entered.connect(Callable(self, "_on_enemy_focus").bind(option["enemy_index"]))
		elif option.has("enemy_index"):
			btn.pressed.connect(Callable(self, option["funcion"]).bind(option["enemy_index"]))
			btn.focus_entered.connect(Callable(self, "_on_enemy_focus").bind(option["enemy_index"]))
		else:
			btn.pressed.connect(Callable(self, option["funcion"]))
		
		action_options_container.add_child(btn)
	
	await get_tree().process_frame
	action_options_container.get_child(0).grab_focus()
