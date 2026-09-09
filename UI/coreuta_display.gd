extends PanelContainer

@export var combatant_data: CombatantData

@onready var container: HBoxContainer = $container
@onready var box_container: BoxContainer = $container/BoxContainer
@onready var display_name: Label = $container/BoxContainer/display_name
@onready var cuerda: Label = $container/BoxContainer/Cuerda
@onready var portrait: TextureRect = $container/BoxContainer/portrait
@onready var data: VBoxContainer = $container/data
@onready var detail: VBoxContainer = $container/detail

@onready var vida: Label = $container/detail/Vida
@onready var vientos: Label = $container/detail/Vientos
@onready var velocidad: Label = $container/detail/Velocidad
@onready var ataque_fisico: Label = $"container/detail/Ataque fisico"
@onready var ataque_magico: Label = $"container/detail/Ataque magico"
@onready var dureza: Label = $container/detail/Dureza
@onready var tonicidad: Label = $container/detail/Tonicidad


func load_coreuta_info(combatant: CombatantData) -> void:
	combatant_data = combatant
	
	portrait.texture = combatant.portrait 
	display_name.text = combatant.display_name # Cambiado a display_name
	
	# Si el combatiente es un Coreuta, mostramos su cuerda; si es enemigo, lo ocultamos o mostramos su tipo
	if combatant is CoreutaData:
		cuerda.text = combatant.cuerda
		cuerda.show()
	else:
		cuerda.hide()
	
	vida.text = "Vida: %s/%s" % [combatant.hp, combatant.hp_max]
	vientos.text = "Vientos: %s/%s" % [combatant.mana, combatant.mana_max]
	velocidad.text = "Velocidad: %s" % combatant.speed
	ataque_fisico.text = "Ataque Fis: %s" % combatant.attack
	ataque_magico.text = "Ataque Mag: %s" % combatant.magic_attack
	dureza.text = "Dureza: %s" % combatant.armor
	tonicidad.text = "Tonicidad: %s" % combatant.magic_armor


func _on_focus_entered() -> void:
	self.self_modulate = Color(0.208, 0.0, 0.639)
	detail.show()


func _on_focus_exited() -> void:
	self.self_modulate = Color(1, 1, 1, 1)
	detail.hide()
