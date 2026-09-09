extends CharacterBody2D
class_name Michellin

@export var active := true
@export var WALK_SPEED: int = 100
var RUN_SPEED: int = WALK_SPEED * 2
enum State { IDLE, WALKING, INTERACT }
@export var state: State = State.IDLE

var velocity_vec: Vector2 = Vector2.ZERO
enum Facing {
	DOWN,
	UP,
	LEFT,
	RIGHT,
	DOWN_LEFT,
	DOWN_RIGHT,
	UP_LEFT,
	UP_RIGHT
}
@export var facing: Facing = Facing.DOWN

var keys_pressed := []
#objetos en area de interaccion
var overlapping_interactables: Array = []
@onready var interact_pivot: Marker2D = $interactPivot
@onready var interaction_area: Area2D = $interactPivot/InteractionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var interacting = false
func _ready() -> void:
	#señal-> concectarcon (funcion)
	UIManager.dialog_panel.dialog_start.connect(_on_dialog_start)
	UIManager.dialog_panel.dialog_end.connect(_on_dialog_end)
	_update_animation()

func _on_dialog_start() -> void:
	active = false

func _on_dialog_end() -> void:
	active = true

var _last_dir: Vector2 = Vector2.DOWN

func _physics_process(_delta: float) -> void:
	$coll.disabled = !active
	if not active:
		velocity_vec = Vector2.ZERO
		state = State.IDLE
		_update_animation()
		return	
		
	match state:
		State.IDLE, State.WALKING:
			var dir := Vector2(
				-int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right")),
				-int(Input.is_action_pressed("move_up")) + int(Input.is_action_pressed("move_down"))
			)
			
			if dir != Vector2.ZERO:
				# Si hay movimiento en diagonal (ambos ejes activos), le damos prioridad a registrar esa dirección
				if dir.x != 0 and dir.y != 0:
					_last_dir = dir
				else:
					_last_dir = dir

				var iso_dir := Vector2(dir.x, dir.y * 0.57).normalized()
				var speed := RUN_SPEED if Input.is_action_pressed("run") else WALK_SPEED
				velocity_vec = iso_dir * speed
				
				state = State.WALKING
				_update_facing(_last_dir)
			else:
				velocity_vec = Vector2.ZERO
				state = State.IDLE
				# Forzamos que en IDLE se use la última dirección guardada
				_update_facing(_last_dir)

	if Input.is_action_just_pressed("accept"):
		if !active: return
		var target = _get_interaction_target()
		if target:
			print("~interacting:", target)
			interact(target)
			
	_update_animation()
	velocity = velocity_vec
	move_and_slide()
func _update_facing(dir: Vector2) -> void:
	# Mapeo directo para las 8 combinaciones posibles de dir (-1, 0, 1)
	match dir:
		Vector2(0, 1):
			facing = Facing.DOWN
			interact_pivot.rotation_degrees = 0
		Vector2(0, -1):
			facing = Facing.UP
			interact_pivot.rotation_degrees = 180
		Vector2(-1, 0):
			facing = Facing.LEFT
			interact_pivot.rotation_degrees = 90
		Vector2(1, 0):
			facing = Facing.RIGHT
			interact_pivot.rotation_degrees = -90
		Vector2(-1, 1):
			facing = Facing.DOWN_LEFT
			interact_pivot.rotation_degrees = 45
		Vector2(1, 1):
			facing = Facing.DOWN_RIGHT
			interact_pivot.rotation_degrees = -45
		Vector2(-1, -1):
			facing = Facing.UP_LEFT
			interact_pivot.rotation_degrees = 135
		Vector2(1, -1):
			facing = Facing.UP_RIGHT
			interact_pivot.rotation_degrees = -135
	if state == State.WALKING:
		_update_animation()

func _update_animation() -> void:
	if not animation_player:
		return
	# Especificamos explícitamente el tipo String
	var facing_name: String = Facing.keys()[facing].to_lower()
	var anim_prefix: String = "idle_" if state == State.IDLE else "move_"
	var anim_name: String = anim_prefix + facing_name
	if animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
	
func _get_cardinal_fallback(f: Facing) -> Facing:
	match f:
		Facing.DOWN_LEFT, Facing.UP_LEFT:
			return Facing.LEFT
		Facing.DOWN_RIGHT, Facing.UP_RIGHT:
			return Facing.RIGHT
		_:
			return f

#devuelve el objeto de interaccion mas cercano
func _get_interaction_target() -> Object: 
	if not overlapping_interactables:
		return null
	overlapping_interactables.sort_custom(_sort_by_distance)
	return overlapping_interactables[0]
#llama al metodo de interaccion
func interact(target: Object) -> void:
	if !target : state = State.IDLE
	if target.has_method("interact"):
		interacting=true
		if target.has_method("face_direction"):
			target.face_direction(self.position)
		target.interact(self)
		state = State.INTERACT

#cunado detecta un area con interaccion lo agrega a la lista de interaccion
func _on_interaction_area_entered(area: Area2D) -> void:
	if area.has_method("interact"):
		if not overlapping_interactables.has(area):
			overlapping_interactables.append(area)

#lo saca de la lista de interaccion
func _on_interaction_area_exited(area: Area2D) -> void:
	if overlapping_interactables.has(area):
		overlapping_interactables.erase(area)

func _sort_by_distance(a: Node, b: Node) -> int:
	var da = (a.global_position - global_position).length_squared()
	var db = (b.global_position - global_position).length_squared()
	return int(da - db)
