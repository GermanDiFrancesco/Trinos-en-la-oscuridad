extends CharacterBody2D

class_name Player

@export var active := true
@export var WALK_SPEED: int = 100
enum State { IDLE, WALKING, INTERACT }
@export var state: State = State.IDLE

var velocity_vec: Vector2 = Vector2.ZERO
enum Facing { DOWN, UP, LEFT, RIGHT }
@export var facing: Facing = Facing.DOWN

var keys_pressed := []
#objetos en area de interaccion
var overlapping_interactables: Array = []
@onready var interact_pivot: Marker2D = $interactPivot
@onready var interaction_area: Area2D = $interactPivot/InteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	interaction_area.area_entered.connect(_on_interaction_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_exited)
	_update_animation()

func _physics_process(_delta: float) -> void:
	$coll.disabled = !active
	if not active:
		return	
	match state:
		State.IDLE, State.WALKING:
			var dir := Vector2(-int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right")),				-int(Input.is_action_pressed("move_up")) + int(Input.is_action_pressed("move_down"))			)
			if dir != Vector2.ZERO:
				dir = dir.normalized()
				velocity_vec = dir * WALK_SPEED
				state = State.WALKING
				_update_facing(dir)
			else:
				velocity_vec = Vector2.ZERO
				state = State.IDLE

			if Input.is_action_just_pressed("accept"):
				var target = _get_interaction_target()
				print("Interaction target:", target)
				if target:
					state = State.INTERACT
					_do_interact(target)
	_update_animation()

	velocity = velocity_vec
	move_and_slide()

func _update_facing(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		if dir.x < 0 :
			facing = Facing.LEFT
			interact_pivot.rotation_degrees = 90
		else:
			facing = Facing.RIGHT
			interact_pivot.rotation_degrees = -90
	else:
		if dir.y < 0:
			facing = Facing.UP
			interact_pivot.rotation_degrees = 180
		else:
			facing = Facing.DOWN
			interact_pivot.rotation_degrees = 0
	# update animation immediately when changing facing while walking
	if state == State.WALKING:
		_update_animation()

func _on_interaction_area_entered(area: Area2D) -> void:#los agrega a la lista de interacciones
	if area.has_method("interact") or area.is_in_group("interactable"):
		if not overlapping_interactables.has(area):
			overlapping_interactables.append(area)
			print('area para interact '+str(area.name))
#TODO esto de la interaccion pasar al manager
func _on_interaction_area_exited(area: Area2D) -> void:#limpia la lista de interaccion
	if overlapping_interactables.has(area):
		overlapping_interactables.erase(area)

func _get_interaction_target() -> Object: #devuelve el objeto interact mas cercano
	if not overlapping_interactables:
		print('interact target:none')
		return null
	overlapping_interactables.sort_custom(_sort_by_distance)
	return overlapping_interactables[0]

func _sort_by_distance(a: Node, b: Node) -> int:
	var da = (a.global_position - global_position).length_squared()
	var db = (b.global_position - global_position).length_squared()
	return int(da - db)

func _do_interact(target: Object) -> void:
	if target == null:
		state = State.IDLE
		return
	if target.has_method("interact"):
		target.interact(self)
	state = State.IDLE
## hasta aca TODO
func _update_animation() -> void:
	if not animation_player:
		return
	var anim_name: String = ""
	match state:
		State.IDLE:
			anim_name = "idle_" + Facing.keys()[facing].to_lower()
		State.WALKING:
			anim_name = "walking_" + Facing.keys()[facing].to_lower()
		_:
			anim_name = "idle"
	if animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
