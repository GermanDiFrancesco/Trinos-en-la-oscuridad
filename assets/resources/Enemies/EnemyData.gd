extends Resource
class_name EnemyData

@export var display_name: String = "Enemigo Contenedor"
@export var portrait: Texture2D
@export var tipo: String = ""
@export_multiline var description: String = "Descripción general del boss/enemigo."

@export_group("Estructura de Combate")
@export var parts: Array[EnemyPartData] = []

func _init(source: EnemyData = null) -> void:
	if source == null:
		return
	display_name = source.display_name
	portrait = source.portrait
	tipo = source.tipo
	description = source.description
	
	parts.clear()
	for part_data in source.parts:
		if part_data:
			parts.append(EnemyPartData.new(part_data))

func clone() -> EnemyData:
	return EnemyData.new(self)

## Devuelve todas las partes que siguen con vida para la línea de turnos
func get_active_parts() -> Array[EnemyPartData]:
	var active: Array[EnemyPartData] = []
	for part in parts:
		if part.is_alive():
			active.append(part)
	return active

## Verifica si el enemigo entero ha sido derrotado (ej: si cayó la parte principal)
func is_defeated() -> bool:
	for part in parts:
		if part.is_weak_point and not part.is_alive():
			return true
	return get_active_parts().is_empty()
