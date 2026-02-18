extends CanvasLayer

# Referencia al panel de pausa
@onready var pause_panel : Panel = $PausePanel
@onready var pause_continuar_btn: TextureButton = $PausePanel/VBoxContainer/ContinuarBtn
@onready var salir_btn: TextureButton = $PausePanel/VBoxContainer/SalirBtn

#refencia a los botones del menú principal
@onready var main_menu: Control = $MainMenu
@onready var continuar_btn: TextureButton = $MainMenu/VBoxContainer/ContinuarBtn
@onready var comenzar_btn: TextureButton = $MainMenu/VBoxContainer/ComenzarBtn
@onready var ajustes_btn: TextureButton = $MainMenu/VBoxContainer/AjustesBtn

#referencias battle panel
@onready var battle_panel: Panel = $BattlePanel
@onready var atacar_btn: TextureButton = $BattlePanel/FondoDelMenu/ActionList/AtacarBtn
@onready var cantar_btn: TextureButton = $BattlePanel/FondoDelMenu/ActionList/CantarBtn
@onready var usar_btn: TextureButton = $BattlePanel/FondoDelMenu/ActionList/UsarBtn
@onready var hablar_btn: TextureButton = $BattlePanel/FondoDelMenu/ActionList/HablarBtn
@onready var correr_btn: TextureButton = $BattlePanel/FondoDelMenu/ActionList/CorrerBtn
@onready var text_container: RichTextLabel = $BattlePanel/DialogBox/MarginContainer/TextContainer
@onready var correr_options: HBoxContainer = $BattlePanel/DialogBox/CorrerOptions
@onready var correr_salir_btn: TextureButton = $BattlePanel/DialogBox/CorrerOptions/SalirBtn
@onready var correr_continuar_btn: TextureButton = $BattlePanel/DialogBox/CorrerOptions/ContinuarBtn


#enemigo
@onready var npc: TextureRect = $BattlePanel/EnemyContainer/Npc
@onready var part_1: TextureRect = $BattlePanel/EnemyContainer/part1
@onready var part_2: TextureRect = $BattlePanel/EnemyContainer/part2
@onready var part_3: TextureRect = $BattlePanel/EnemyContainer/part3
@onready var part_4: TextureRect = $BattlePanel/EnemyContainer/part4
@onready var part_5: TextureRect = $BattlePanel/EnemyContainer/part5
@onready var part_6: TextureRect = $BattlePanel/EnemyContainer/part6

var enemy = null
var player = null

func _ready():
	# Verificamos si existe el archivo de guardado
	#pasar a global
	if not FileAccess.file_exists("user://save_game.dat"):
		continuar_btn.visible = false
	else:
		continuar_btn.visible = true
	show_main_menu()
	
# Menu management functions
func show_main_menu():
	hide_panels()
	main_menu.visible = true
	comenzar_btn.grab_focus()
# BUTTONS LOGIC
func _on_comenzar_pressed():
	Global.changeState("GAME")
func _on_ajustes_pressed():
	Global.changeState("AJUSTES")
func _on_continuar_pressed():
	Global.changeState("GAME")

func hide_panels():
	main_menu.visible = false
	pause_panel.visible = false
	battle_panel.visible = false

# Pause management functions
func show_pause():
	hide_panels()
	pause_panel.visible = true
	salir_btn.grab_focus()

func _on_salir_btn_pressed() -> void:
	Global.changeState("MENU")
func _on_continuar_btn_pressed() -> void:
	pause_panel.visible = false
	Global.changeState("GAME")

# BATTLE
func show_battle_panel():
	hide_panels()
	battle_panel.visible = true
	atacar_btn.grab_focus()
func _on_atacar_btn_pressed() -> void:
	show_attack_options()

func _on_cantar_btn_pressed() -> void:
	show_sing_options()

func _on_usar_btn_pressed() -> void:
	show_items_options()

func _on_hablar_btn_pressed() -> void:
	show_talk_options()

func _on_correr_btn_pressed() -> void:
	text_container.text = "Quieres intentar escapar de la batalla?"
	show_escape_confirmation()



#FOCUS action descriptions
func _on_atacar_btn_focus_entered() -> void:
	text_container.text = "Ataca al enemigo cuerpo a cuerpo"
func _on_cantar_btn_focus_entered() -> void:
	text_container.text = "Canta para distraer al enemigo y reducir su ataque"
func _on_usar_btn_focus_entered() -> void:
	text_container.text = "Usa un objeto del inventario para ayudarte en la batalla"
func _on_hablar_btn_focus_entered() -> void:
	text_container.text = "Habla con el enemigo para intentar persuadirlo o distraerlo"
func _on_correr_btn_focus_entered() -> void:
	text_container.text = "Intenta escapar de la batalla"

#CORRER options
func show_escape_confirmation() -> void:
	correr_options.visible = true
	correr_salir_btn.grab_focus()
func _on_correr_salir_btn_pressed() -> void:
	correr_options.visible=false
	text_container.text = "Que deberia a hacer"
	atacar_btn.grab_focus()
func _on_correr_continuar_btn_pressed() -> void:
	correr_options.visible=false
	Global.changeState("GAME")



func show_attack_options():
	text_container.text = "Selecciona un ataque para usar contra el enemigo"
	show_escape_confirmation()
func show_talk_options():
	text_container.text = "Selecciona una opción de conversación para intentar persuadir al enemigo"
	show_escape_confirmation()
func show_sing_options():
	text_container.text = "Selecciona una canción para distraer al enemigo"
	show_escape_confirmation()
func show_items_options():
	text_container.text = "Selecciona un objeto del inventario para usar en la batalla"
	show_escape_confirmation()

