extends Node3D

# ========== 設定 ==========
@export var open_angle: float = -90.0
@export var close_angle: float = 0.0
@export var animation_speed: float = 0.5

# ========== 節點引用 ==========
@onready var door_mesh = $DoorMesh
@onready var audio_player = $AudioStreamPlayer3D

# ========== 變數 ==========
var is_open := false
var tween: Tween

# ========== 互動功能 ==========
@rpc("any_peer", "call_local")
func interact():
	toggle_door()

func toggle_door():
	if tween and tween.is_running():
		return
	
	tween = create_tween()
	
	if is_open:
		# 關門
		tween.tween_property(door_mesh, "rotation:y", deg_to_rad(close_angle), animation_speed)
	else:
		# 開門
		tween.tween_property(door_mesh, "rotation:y", deg_to_rad(open_angle), animation_speed)
	
	is_open = !is_open
	
	# 播放音效
	if audio_player:
		audio_player.play()
	
	# 更新語音濾鏡
	update_voice_filter()

func update_voice_filter():
	# 根據門的狀態更新語音濾鏡
	if is_open:
		# 開門：移除低通濾鏡
		remove_low_pass_filter()
	else:
		# 關門：加上低通濾鏡
		add_low_pass_filter()

func add_low_pass_filter():
	# 檢查是否已有濾鏡
	if AudioServer.get_bus_effect_count(1) > 0:
		return
	
	# 建立低通濾鏡
	var filter = AudioEffectLowPassFilter.new()
	filter.cutoff_frequency = 1000.0
	AudioServer.add_bus_effect(1, filter)

func remove_low_pass_filter():
	# 移除濾鏡
	if AudioServer.get_bus_effect_count(1) > 0:
		AudioServer.remove_bus_effect(1, 0)
