extends Node3D

# ========== 設定 ==========
@export var unlock_animation_time: float = 3.0

# ========== 節點引用 ==========
@onready var gate_mesh = $GateMesh
@onready var lock_mesh = $LockMesh
@onready var broadcast_player = $BroadcastPlayer
@onready var interact提示 = $InteractPrompt

# ========== 變數 ==========
var is_unlocked := false
var is_opening := false

# ========== 初始化 ==========
func _ready():
	add_to_group("main_gate")
	
	# 連接遊戲管理器信號
	game_manager.exorcism_completed.connect(_on_exorcism_completed)

# ========== 互動 ==========
@rpc("any_peer", "call_local")
func interact():
	if is_unlocked:
		open_gate()

func open_gate():
	if is_opening:
		return
	
	is_opening = true
	
	# 播放開門動畫
	var tween = create_tween()
	tween.tween_property(gate_mesh, "rotation:y", deg_to_rad(-90), unlock_animation_time)
	
	# 播放開門音效
	if audio_manager:
		audio_manager.play_sfx("gate_open")
	
	# 遊戲勝利
	game_manager.end_game(true)

# ========== 解鎖 ==========
func _on_exorcism_completed():
	unlock()
	unlock_effects()

func unlock():
	is_unlocked = true
	print("[MainGate] 大門已解鎖！")

func unlock_effects():
	# 1. 播放復古軍樂
	if broadcast_player:
		broadcast_player.play()
	
	# 2. 引誘所有黑霧到大門
	var fogs = get_tree().get_nodes_in_group("fog_ai")
	for fog in fogs:
		fog.attract_to_gate()
	
	# 3. 顯示訊息
	print("[MainGate] 🔊 復古軍樂播放中！黑霧被引誘過來！")

# ========== 重設 ==========
func reset():
	is_unlocked = false
	is_opening = false
	
	if gate_mesh:
		gate_mesh.rotation.y = 0
	
	if broadcast_player:
		broadcast_player.stop()
