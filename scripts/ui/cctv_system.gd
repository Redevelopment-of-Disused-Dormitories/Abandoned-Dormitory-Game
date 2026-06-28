extends Control

# ========== 節點引用 ==========
@onready var camera_viewport = $CameraViewport
@onready var camera_label = $CameraLabel
@onready var radio_button = $RadioButton

# ========== 變數 ==========
var cameras: Array[Camera3D] = []
var current_camera_index: int = 0
var is_active: bool = false

# ========== 初始化 ==========
func _ready():
	visible = false
	find_cameras()

func find_cameras():
	# 尋找場景中所有 CCTV 攝影機
	cameras = get_tree().get_nodes_in_group("cctv_camera")
	if cameras.size() > 0:
		update_camera_label()

# ========== 觀戰控制 ==========
func activate():
	is_active = true
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# 切換到第一台攝影機
	if cameras.size() > 0:
		switch_camera(0)

func deactivate():
	is_active = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func switch_camera(index: int):
	if index < 0 or index >= cameras.size():
		return
	
	# 關閉目前攝影機
	if cameras[current_camera_index]:
		cameras[current_camera_index].current = false
	
	# 切換到新攝影機
	current_camera_index = index
	cameras[current_camera_index].current = true
	
	# 更新標籤
	update_camera_label()
	
	print("[CCTV] 切換到攝影機: ", current_camera_index + 1)

func update_camera_label():
	if camera_label and cameras.size() > 0:
		camera_label.text = "CAM " + str(current_camera_index + 1) + "/" + str(cameras.size())

# ========== 輸入處理 ==========
func _input(event):
	if not is_active:
		return
	
	# A/D 切換攝影機
	if event.is_action_pressed("camera_left"):
		var new_index = current_camera_index - 1
		if new_index < 0:
			new_index = cameras.size() - 1
		switch_camera(new_index)
	
	if event.is_action_pressed("camera_right"):
		var new_index = (current_camera_index + 1) % cameras.size()
		switch_camera(new_index)
	
	# ESC 退出觀戰
	if event.is_action_pressed("ui_cancel"):
		deactivate()
