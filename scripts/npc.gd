extends Area2D

# Configuration
@export var WALK_SPEED: int = 100
@export var WAIT_TIME: float = 2.0
@export var PATROL_DISTANCE: int = 64

# NUEVO: Enemigos que este NPC triggerea al interactuar
@export var encounter_enemies: Array[EnemyData] = []

# Animation
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# State Machine
enum State { IDLE, WALKING, PATROL }
var state: State = State.IDLE
var prev_state: State = State.IDLE

# Movement
var velocity_vec: Vector2 = Vector2.ZERO
var facing := "down"
var patrol_points: Array = []
var current_patrol_index: int = 0
var patrol_forward: bool = true
var patrol_origin: Vector2

# Interaction
@onready var interact_pivot: Marker2D = $interactPivot

# Timer
@onready var wait_timer: Timer = $Timer

signal wait_timer_timeout
var interacted: bool = false


func interact(_target):
	# Ahora pasa los datos de los enemigos configurados en el Inspector
	if encounter_enemies.is_empty():
		print("[NPC] No tiene enemigos configurados, usando batalla por defecto")
		Global.changeState("BATTLE")
	else:
		Global.start_battle(encounter_enemies)
	return true


# El resto del código de patrulla/movimiento permanece IGUAL
func _ready() -> void:
	state = State.PATROL
	prev_state = state
	patrol_origin = global_position
	_define_patrol_points()
	_update_animation()
	wait_timer.wait_time = WAIT_TIME
	wait_timer.one_shot = true
	wait_timer.connect("timeout", Callable(self, "_on_wait_timer_timeout"))


func _define_patrol_points() -> void:
	patrol_points.clear()
	patrol_points.append(patrol_origin + Vector2(PATROL_DISTANCE, 0))
	patrol_points.append(patrol_origin + Vector2(-PATROL_DISTANCE, 0))


func _physics_process(delta: float) -> void:
	var moving = false
	match state:
		State.IDLE:
			velocity_vec = Vector2.ZERO
			moving = false
		State.PATROL:
			moving = _handle_patrol()
		State.WALKING:
			moving = _handle_walking()
	if velocity_vec != Vector2.ZERO:
		_update_facing(velocity_vec)
	if state != prev_state:
		prev_state = state
	global_position += velocity_vec * delta
	_update_animation()


func _update_facing(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		if dir.x < 0:
			facing = "left"
			interact_pivot.rotation_degrees = 90
		else:
			facing = "right"
			interact_pivot.rotation_degrees = -90
	else:
		if dir.y < 0:
			facing = "up"
			interact_pivot.rotation_degrees = 180
		else:
			facing = "down"
			interact_pivot.rotation_degrees = 0
	if state == State.WALKING:
		_update_animation()


func set_state(new_state: State) -> void:
	if new_state != state:
		prev_state = state
		state = new_state
		_update_animation()
		if state == State.IDLE:
			_restart_wait_timer()


func _handle_patrol() -> bool:
	var patrol_count := patrol_points.size()
	if patrol_count == 0:
		set_state(State.IDLE)
		return false
	var target_pos: Vector2
	if patrol_forward:
		target_pos = patrol_points[current_patrol_index]
	else:
		target_pos = patrol_origin
	
	var dir = (target_pos - global_position)
	if dir.length() < 2.0:
		velocity_vec = Vector2.ZERO
		if patrol_forward:
			current_patrol_index += 1
			if current_patrol_index >= patrol_count:
				current_patrol_index = 0
				patrol_forward = false
		else:
			patrol_forward = true
		set_state(State.IDLE)
		return false
	else:
		velocity_vec = dir.normalized() * WALK_SPEED
		return true


func _handle_walking() -> bool:
	return false


func _restart_wait_timer() -> void:
	wait_timer.start()


func _on_wait_timer_timeout() -> void:
	set_state(State.PATROL)


func _update_animation() -> void:
	if not animation_player:
		return
	var anim_name: String = ""
	match state:
		State.IDLE:
			anim_name = "idle_" + facing
		State.PATROL, State.WALKING:
			anim_name = "walking_" + facing
		_:
			anim_name = "idle_" + facing
	if animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
