extends Node

# ========== 設定 ==========
@export var walk_interval: float = 0.5
@export var run_interval: float = 0.3
@export var crouch_interval: float = 0.8

# ========== 節點引用 ==========
@onready var audio_player = $AudioStreamPlayer3D

# ========== 變數 ==========
var step_timer: float = 0.0
var is_moving := false
var is_running := false
var is_crouching := false

# ========== 腳步聲檔案 ==========
var footstep_sounds: Array = [
	"res://assets/audio/sfx/footstep_01.wav",
	"res://assets/audio/sfx/footstep_02.wav",
	"res://assets/audio/sfx/footstep_03.wav",
	"res://assets/audio/sfx/footstep_04.wav"
]

func _process(delta):
	if is_moving:
		step_timer += delta
		var interval = get_current_interval()
		if step_timer >= interval:
			step_timer = 0.0
			play_footstep()

func get_current_interval() -> float:
	if is_running:
		return run_interval
	elif is_crouching:
		return crouch_interval
	else:
		return walk_interval

func play_footstep():
	if footstep_sounds.size() == 0:
		return
	
	var random_index = randi() % footstep_sounds.size()
	var stream = load(footstep_sounds[random_index])
	if stream and audio_player:
		audio_player.stream = stream
		audio_player.pitch_scale = randf_range(0.9, 1.1)
		audio_player.play()

func set_moving(moving: bool):
	is_moving = moving
	if not moving:
		step_timer = 0.0

func set_running(running: bool):
	is_running = running

func set_crouching(crouching: bool):
	is_crouching = crouching
