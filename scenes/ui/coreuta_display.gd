extends PanelContainer
@export var coreuta_data :CoreutaData

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

	
func load_coreuta_info(coreuta:CoreutaData):
	portrait.texture = coreuta.portrait
	display_name.text = coreuta.display_name
	vida.text = "Vida: " + str(coreuta.hp)
	vientos.text = "Vientos: " + str(coreuta.max_mana)
	velocidad.text = "Velocidad: " + str(coreuta.speed)
	ataque_magico.text = "Ataque Mag: " + str(coreuta.magic_attack)
	ataque_fisico.text = "Ataque Fis: " + str(coreuta.attack)
	dureza.text = "Dureza: " + str(coreuta.armor)
	tonicidad.text = "Tonicidad: " + str(coreuta.magic_armor)

func _on_focus_entered() -> void:
	self.self_modulate = Color(0.208, 0.0, 0.639)
	detail.show()

func _on_focus_exited() -> void:
	self.self_modulate = Color(1,1,1,1)
	
	detail.hide()
	
	
