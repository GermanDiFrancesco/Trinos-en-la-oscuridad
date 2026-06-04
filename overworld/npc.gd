extends Interactuable
class_name Npc

@export_group("Configuración Visual")
var is_interacting: bool = false
enum Facing { DOWN, UP, LEFT, RIGHT }
@export var facing: Facing = Facing.DOWN
@export_enum("enemy","andante","caminante","james", "daniel", "kruta","piter") var npcSprite: String = ""

@export_group("Movimiento")
@export var WALK_SPEED: int = 100
@export var WAIT_TIME: float = 2.0
@export var PATROL_DISTANCE: int = 64

# Máquina de estados ahora en la clase madre
enum State { IDLE, WALKING, PATROL }
var state: State = State.IDLE
var prev_state: State = State.IDLE

var velocity_vec: Vector2 = Vector2.ZERO
var patrol_points: Array = []
var current_patrol_index: int = 0
var patrol_forward: bool = true
var patrol_origin: Vector2

# Nodo Timer creado por código para que no dependa de que recuerdes añadirlo en la escena
var wait_timer: Timer 

# Destino dinámico para el movimiento custom
var custom_target_pos: Vector2 = Vector2.ZERO

@onready var sprite_sheet = $Spritesheet
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	sprite_sheet = $Spritesheet
	setup_visuals()
	
	# Inicializar el Timer dinámicamente
	wait_timer = Timer.new()
	add_child(wait_timer)
	wait_timer.wait_time = WAIT_TIME
	wait_timer.one_shot = true
	wait_timer.connect("timeout", Callable(self, "_on_wait_timer_timeout"))
	
	# Configuración inicial de patrulla
	patrol_origin = global_position
	_define_patrol_points()
	
	# Si tiene distancia de patrulla, arranca patrullando; si es 0, se queda IDLE
	if PATROL_DISTANCE > 0:
		set_state(State.PATROL)
	else:
		set_state(State.IDLE)

func _physics_process(delta: float) -> void:
	if is_interacting:
		velocity_vec = Vector2.ZERO
		_update_animation()
		return
	match state:
		State.IDLE:
			velocity_vec = Vector2.ZERO
		
		State.PATROL:
			_handle_patrol()
		
		State.WALKING:
			_handle_walking()
			
	if velocity_vec != Vector2.ZERO:
		_update_facing(velocity_vec)
		
	global_position += velocity_vec * delta

func move_to_target(target_position: Vector2) -> void:
	custom_target_pos = target_position
	set_state(State.WALKING)

func _handle_walking() -> void:
	var dir = custom_target_pos - global_position
	if dir.length() < 2.0:
		velocity_vec = Vector2.ZERO
		set_state(State.IDLE)
	else:
		velocity_vec = dir.normalized() * WALK_SPEED

func _handle_patrol() -> void:
	var patrol_count := patrol_points.size()
	if patrol_count == 0:
		set_state(State.IDLE)
		return
		
	var target_pos: Vector2 = patrol_points[current_patrol_index] if patrol_forward else patrol_origin
	var dir = target_pos - global_position
	
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
	else:
		velocity_vec = dir.normalized() * WALK_SPEED

func _define_patrol_points() -> void:
	patrol_points.clear()
	if PATROL_DISTANCE > 0:
		patrol_points.append(patrol_origin + Vector2(PATROL_DISTANCE, 0))
		patrol_points.append(patrol_origin + Vector2(-PATROL_DISTANCE, 0))

func _update_facing(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		facing = Facing.LEFT if dir.x < 0 else Facing.RIGHT
	else:
		facing = Facing.UP if dir.y < 0 else Facing.DOWN
	_update_animation()

func set_state(new_state: State) -> void:
	if new_state != state:
		prev_state = state
		state = new_state
		_update_animation()
		if state == State.IDLE and wait_timer:
			if PATROL_DISTANCE > 0:
				wait_timer.start()

func _on_wait_timer_timeout() -> void:
	set_state(State.PATROL)

func _update_animation() -> void:
	if not animation_player:
		return
	var facing_str = {
		Facing.DOWN: "down",
		Facing.UP: "up",
		Facing.LEFT: "left",
		Facing.RIGHT: "right"
	}
	var prefix = "idle"
	if state == State.PATROL or state == State.WALKING:
		prefix = "walking"

	var anim_name = prefix + "_" + facing_str.get(facing, "down")
	if animation_player.has_animation(anim_name):
		animation_player.play(anim_name)

func setup_visuals():
	var path = "res://assets/pjs_spritesheet/" + npcSprite + "_walking.png"
	sprite_sheet.texture = load(path)
	_update_animation()

func face_direction(target_position: Vector2) -> void:
	var direction = target_position - global_position
	if abs(direction.x) > abs(direction.y):
		facing = Facing.RIGHT if direction.x > 0 else Facing.LEFT
	else:
		facing = Facing.DOWN if direction.y > 0 else Facing.UP
	_update_animation()

func procesar_dialogo():
	var opciones_preparadas = _preparar_opciones()
	UIManager.dialog_panel.show_dialog(npcSprite.capitalize(), datos_dialogo.texto_principal, opciones_preparadas)

func _procesar_evento(id: String):
	match id:
		"baritono_selected": Global.saved_data.select_cuerda("baritono")
		"tenor_selected":    Global.saved_data.select_cuerda("tenor")
		"mezzo_selected":    Global.saved_data.select_data("mezzo")
		"soprano_selected":  Global.saved_data.select_cuerda("soprano")
		"battle":            Global.change_state("BATTLE")
		"custom":            UIManager.dialog_panel.show_dialog(npcSprite.capitalize(), 'siguiente dialogo')
		_:
			super._procesar_evento(id)
