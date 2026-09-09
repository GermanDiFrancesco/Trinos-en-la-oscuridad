extends CharacterBody2D
class_name Player

@export_category("Movimiento")
@export var active: bool = true
@export var walk_speed: int = 100
@onready var run_speed: int = walk_speed * 2

@export_category("Referencias")
@onready var interact_pivot: Marker2D = $interactPivot
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $coll

enum State { IDLE, WALKING, INTERACT }
@export var state: State = State.IDLE

enum Facing { DOWN, UP, LEFT, RIGHT }
@export var facing: Facing = Facing.DOWN

var overlapping_interactables: Array = []

func _ready() -> void:
	_update_animation()

func _physics_process(_delta: float) -> void:
	collision_shape.disabled = not active
	if not active:
		_handle_inactive_state()
		return
		
	_handle_movement_input()
	_handle_interaction_input()
	
	_update_animation()
	move_and_slide()

# GESTIÓN DE ESTADOS E INPUT
func _handle_inactive_state() -> void:
	velocity = Vector2.ZERO
	state = State.IDLE
	_update_animation()

func _handle_movement_input() -> void:
	var raw_dir := Vector2(
		-int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right")),
		-int(Input.is_action_pressed("move_up")) + int(Input.is_action_pressed("move_down"))
	)
	
	if raw_dir != Vector2.ZERO:
		# Factor de corrección para perspectiva isométrica 2:1
		var iso_dir := Vector2(raw_dir.x, raw_dir.y * 0.534).normalized()
		var current_speed := run_speed if Input.is_action_pressed("run") else walk_speed
		
		velocity = iso_dir * current_speed
		state = State.WALKING
		_update_facing(raw_dir)
	else:
		velocity = Vector2.ZERO
		state = State.IDLE

func _handle_interaction_input() -> void:
	if Input.is_action_just_pressed("accept"):
		var target = _get_interaction_target()
		if target and target.has_method("interact"):
			state = State.INTERACT
			target.interact(self)

# DIRECCIÓN Y ANIMACIONES
func _update_facing(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		if dir.x < 0:
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

	if state == State.WALKING:
		_update_animation()

func _update_animation() -> void:
	if not animation_player:
		return
	var facing_name = Facing.keys()[facing].to_lower()
	var anim_name = ""
	match state:
		State.IDLE:
			anim_name = "idle_" + facing_name
		State.WALKING:
			anim_name = "walking_" + facing_name
		_:
			anim_name = "idle_" + facing_name
			
	if animation_player.has_animation(anim_name):
		animation_player.play(anim_name)

# SISTEMA DE INTERACCIÓN (ÁREAS)
func _get_interaction_target() -> Object:
	if overlapping_interactables.is_empty():
		return null
	overlapping_interactables.sort_custom(_sort_by_distance)
	return overlapping_interactables[0]

func _on_interaction_area_entered(area: Area2D) -> void:
	if area.has_method("interact") and not overlapping_interactables.has(area):
		overlapping_interactables.append(area)

func _on_interaction_area_exited(area: Area2D) -> void:
	if overlapping_interactables.has(area):
		overlapping_interactables.erase(area)

func _sort_by_distance(a: Node, b: Node) -> int:
	var da = (a.global_position - global_position).length_squared()
	var db = (b.global_position - global_position).length_squared()
	return int(da - db)
