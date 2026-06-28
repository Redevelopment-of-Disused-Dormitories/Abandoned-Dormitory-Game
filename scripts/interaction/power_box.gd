extends Node3D

# ========== 設定 ==========
@export var repair_time: float = 5.0

# ========== 節點引用 ==========
@onready var progress_bar = $ProgressBar3D
@onready var interact提示 = $InteractPrompt

# ========== 變數 ==========
var is_repairing := false
var repair_progress: float = 0.0
var is_repaired := false

# ========== 互動 ==========
@rpc("any_peer", "call_local")
func interact():
	if is_repaired:
		return
	
	if not is_repairing:
		start_repair()

func start_repair():
	is_repairing = true
	repair_progress = 0.0
	
	# 顯示進度條
	if progress_bar:
		progress_bar.visible = true
	
	# 開始修復計時
	var tween = create_tween()
	tween.tween_property(self, "repair_progress", 1.0, repair_time)
	tween.tween_callback(finish_repair)
	
	# 同步進度條
	if progress_bar:
		progress_bar.tween_progress(repair_progress, repair_time)

func finish_repair():
	is_repairing = false
	is_repaired = true
	
	# 隱藏進度條
	if progress_bar:
		progress_bar.visible = false
	
	# 通知遊戲管理器
	print("[PowerBox] 配電盤修復完成！")
	
	# 觸發供電恢復事件
	EventBus.power_restored.emit()

func reset():
	is_repairing = false
	is_repaired = false
	repair_progress = 0.0
	
	if progress_bar:
		progress_bar.visible = false
