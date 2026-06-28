extends Node3D

# ========== 設定 ==========
@export var display_distance: float = 10.0
@export var fade_distance: float = 5.0

# ========== 節點引用 ==========
@onready var name_label = $NameLabel
@onready var mic_indicator = $MicIndicator

# ========== 變數 ==========
var player_name: String = ""
var is_talking := false
var camera: Camera3D

func _ready():
	# 等待攝影機載入
	await get_tree().process_frame
	camera = get_viewport().get_camera_3d()

func _process(delta):
	if camera and name_label:
		update_visibility()
		update_label_orientation()

func update_visibility():
	var distance = camera.global_position.distance_to(global_position)
	
	if distance <= display_distance:
		visible = true
		# 根據距離調整透明度
		var alpha = clamp((display_distance - distance) / fade_distance, 0.0, 1.0)
		name_label.modulate.a = alpha
	else:
		visible = false

func update_label_orientation():
	# 讓名牌永遠面向攝影機
	if camera:
		name_label.look_at(camera.global_position, Vector3.UP)

func set_player_name(name: String):
	player_name = name
	if name_label:
		name_label.text = name

func set_talking(talking: bool):
	is_talking = talking
	if mic_indicator:
		if talking:
			mic_indicator.modulate = Color.GREEN
			mic_indicator.visible = true
		else:
			mic_indicator.visible = false
