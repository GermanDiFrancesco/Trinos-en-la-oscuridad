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
	show_options()

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

#Recibe un texto general y una lista de opciones, cada opción es un diccionario con nombre, funcion y descripcion

func show_options(general_text: String = "", options: Array = []) -> void:
	for child in action_options_container.get_children():
		child.queue_free()
	if general_text:
		display_text(general_text)
	if options.is_empty():
		options = [
		{
			"nombre": "Opción 1",
			"funcion": "init",
			"descripcion": "cancelar"
		},
		{
			"nombre": "Opción 2",
			"funcion": "init",
			"descripcion": "cancelar"
		}
	]
	for option in options:
		var btn := Button.new()
		btn.text = option["nombre"]
		btn.pressed.connect(Callable(self, option["funcion"]))
		action_options_container.add_child(btn)
	action_options_container.get_child(0).grab_focus()
