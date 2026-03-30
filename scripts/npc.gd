extends Area2D

# Enums para dirección y sprite
enum Facing { DOWN, UP, LEFT, RIGHT }
@export var facing: Facing = Facing.DOWN
@export_enum (
	"ANTONELLA", "AXEL", "AZUL", "BENJAMIN", "DANIEL", "FREYJA", "ISIDORO", "JESS", "JOHANNA", "JOHN",
	"JONATHAN", "JUAN", "kruta", "LEONA", "LUCERO", "MARCELO", "MARÍA", "MILENA", "MINSI", "PATRI",
	"PETER", "RAFAEL", "RICARDO", "RIHANNA", "RUTH", "SHAO", "THIAGO", "VALENTÍN") var npcSprite: String = ""

@onready var sprite_sheet = $Spritesheet
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	var path = "res://assets/overworld/"+npcSprite+"_walking.png"
	if path != "":
		sprite_sheet.texture = load(path)

	match facing:
		Facing.DOWN:
			animation_player.play("idle_down")
		Facing.UP:
			animation_player.play("idle_up")	
		Facing.LEFT:
			animation_player.play("idle_left")
		Facing.RIGHT:
			animation_player.play("idle_right")
