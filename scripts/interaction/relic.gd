extends Node3D

# ========== 設定 ==========
@export var relic_name: String = "神秘遺物"
@export var relic_id: int = 0

# ========== 節點引用 ==========
@onready var mesh_instance = $MeshInstance3D
@onready var collision_shape = $CollisionShape3D
@onready var interact提示 = $InteractPrompt

# ========== 變數 ==========
var is_collected := false

# ========== 初始化 ==========
func _ready():
	add_to_group("relics")

# ========== 互動 ==========
@rpc("any_peer", "call_local")
func interact():
	if is_collected:
		return
	
	collect()

func collect():
	is_collected = true
	
	# 隱藏物品
	visible = false
	collision_shape.disabled = true
	
	# 通知遊戲管理器
	game_manager.collect_relic()
	
	# 播放收集音效
	if audio_manager:
		audio_manager.play_sfx("relic_collected")
	
	print("[Relic] 收集遺物: ", relic_name, " (", relic_id, ")")

func reset():
	is_collected = false
	visible = true
	collision_shape.disabled = false
