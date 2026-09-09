extends Resource
class_name SkillData

@export_category("Información Básica")
@export var skill_name: String = "Nueva Habilidad"
@export var icon: Texture2D # Agregado: Muy útil para mostrar en los menús de batalla
@export_multiline var description: String = "Descripción manual aquí..."

@export_group("Requisitos")
@export var mana_cost: int = 0
# Mantenemos las mismas cuerdas que definimos en CoreutaData para evitar inconsistencias
@export_enum("Sin cuerda", "Soprano", "Mezzo", "Contralto", "Tenor", "Barítono", "Bajo") var cuerda_requerida: String = "Sin cuerda"

@export_group("Comportamiento")
# Cambié "attack" a "physical" para que coincida con physical/magic damage. 
# Agregué "heal" ya que mencionaste "curación" en tu comentario original.
@export_enum("physical", "magic", "heal", "buff", "debuff") var type: String = "magic"

# Hice los objetivos un poco más explícitos para no confundir aliados con enemigos
@export_enum("single_enemy", "all_enemies", "single_ally", "all_allies", "self") var target: String = "single_enemy"

@export var power: int = 1 


# ==========================================
# MÉTODOS AUXILIARES
# ==========================================

# Genera un resumen dinámico de la habilidad (reemplaza tu string concatenado)
func get_tooltip() -> String:
	return "%s\nTipo: %s | Objetivo: %s\nPoder: %d | Costo: %d Vientos\n\n%s" % [
		skill_name, type.capitalize(), target.capitalize(), power, mana_cost, description
	]

# Utilidades rápidas para la IA de los enemigos o la lógica de batalla
func is_damaging() -> bool:
	return type == "physical" or type == "magic"

func is_healing() -> bool:
	return type == "heal"
