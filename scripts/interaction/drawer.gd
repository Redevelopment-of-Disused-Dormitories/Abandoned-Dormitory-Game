extends Node3D

# ========== 設定 ==========
@export var open_offset: Vector3 = Vector3(0, 0, -0.5)
@export var animation_speed: float = 0.3

# ========== 節點引用 ==========
@onready var drawer_mesh = $DrawerMesh
@onready var audio_player = $AudioStreamPlayer3D

# ========== 變數 ==========
var is_open := false
var tween: Tween
var original_position: Vector3

# ========== 初始化 ==========
func _ready():
	original_position = drawer_mesh.position

# ========== 互動 ==========
@rpc("any_peer", "call_local")
func interact():
	toggle_drawer()

func toggle_drawer():
	if tween and tween.is_running():
		return
	
	tween = create_tween()
	
	if is_open:
		# 關閉抽屜
		tween.tween_property(drawer_mesh, "position", original_position, animation_speed)
	else:
		# 開啟抽屜
		tween.tween_property(drawer_mesh, "position", original_position + open_offset, animation_speed)
	
	is_open = !is_open
	
	# 播放音效
	if audio_player:
		audio_player.play()
