extends Node3D

# ========== 設定 ==========
@export var disrupt_range: float = 15.0
@export var disrupt_duration: float = 3.0
@export var disrupt_cooldown: float = 5.0

# ========== 節點引用 ==========
@onready var audio_player = $AudioStreamPlayer3D
@onready var interference_effect = $InterferenceEffect

# ========== 變數 ==========
var is_disrupting := false
var can_disrupt := true
var disruption_timer: float = 0.0

# ========== 初始化 ==========
func _ready():
	add_to_group("radio")

func _process(delta):
	if is_disrupting:
		disruption_timer -= delta
		if disruption_timer <= 0:
			stop_disruption()

# ========== 干擾功能 ==========
func start_disruption():
	if not can_disrupt or is_disrupting:
		return
	
	is_disrupting = true
	can_disrupt = false
	disruption_timer = disrupt_duration
	
	# 播放干擾音效
	if audio_player:
		audio_player.play()
	
	# 啟用干擾效果
	if interference_effect:
		interference_effect.visible = true
		interference_effect.emitting = true
	
	# 影響範圍內的玩家
	affect_nearby_players()
	
	print("[Radio] 開始干擾！")

func stop_disruption():
	is_disrupting = false
	
	# 停止干擾音效
	if audio_player:
		audio_player.stop()
	
	# 關閉干擾效果
	if interference_effect:
		interference_effect.visible = false
		interference_effect.emitting = false
	
	# 冷卻時間
	await get_tree().create_timer(disrupt_cooldown).timeout
	can_disrupt = true
	
	print("[Radio] 干擾結束")

func affect_nearby_players():
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		var distance = global_position.distance_to(player.global_position)
		if distance <= disrupt_range:
			apply_distortion_to_player(player)

func apply_distortion_to_player(player):
	# 對玩家施加語音失真效果
	if player.has_node("VoicePlayer"):
		var voice_player = player.get_node("VoicePlayer")
		# 加入失真效果
		var distortion = AudioEffectDistortion.new()
		distortion.drive = 0.8
		AudioServer.add_bus_effect(voice_player.bus, distortion)
		
		# 一段時間後移除
		await get_tree().create_timer(disrupt_duration).timeout
		if AudioServer.get_bus_effect_count(voice_player.bus) > 0:
			AudioServer.remove_bus_effect(voice_player.bus, 0)
