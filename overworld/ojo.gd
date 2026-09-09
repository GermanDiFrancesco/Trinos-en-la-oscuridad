extends Node2D

const ANIMS = ["left_look", "right_look", "wink"]
const IDLE_ANIM = "idle"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	animation_player.animation_finished.connect(_on_animation_finished)
	animation_player.play(IDLE_ANIM)
	_start_random_timer()
func _start_random_timer() -> void:
	var wait_time = randf_range(5.0, 10.0)
	timer.start(wait_time)

func _on_timer_timeout() -> void:
	var random_anim = ANIMS.pick_random()
	animation_player.play(random_anim)

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name != IDLE_ANIM:
		animation_player.play(IDLE_ANIM)
		_start_random_timer()
