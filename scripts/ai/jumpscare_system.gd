extends CanvasLayer

# ========== 設定 ==========
@export var jumpscare_duration: float = 0.5
@export var shake_intensity: float = 10.0
@export var shake_duration: float = 0.3

# ========== 節點引用 ==========
@onready var jumpscare_sprite = $JumpscareSprite
@onready var black_overlay = $BlackOverlay
@onready var audio_player = $AudioStreamPlayer

# ========== 變數 ==========
var is_showing := false

# ========== 初始化 ==========
func _ready():
	visible = false
	jumpscare_sprite.visible = false
	black_overlay.visible = false

# ========== 驚嚇功能 ==========
func show_jumpscare():
	if is_showing:
		return
	
	is_showing = true
	visible = true
	
	# 顯示驚嚇圖片
	jumpscare_sprite.visible = true
	jumpscare_sprite.modulate = Color(1, 1, 1, 0)
	
	# 淡入動畫
	var tween = create_tween()
	tween.tween_property(jumpscare_sprite, "modulate:a", 1.0, 0.1)
	
	# 播放驚嚇音效
	if audio_player:
		audio_player.play()
	
	# 螢幕震動
	apply_screen_shake()
	
	# 等待後隱藏
	await get_tree().create_timer(jumpscare_duration).timeout
	hide_jumpscare()

func hide_jumpscare():
	jumpscare_sprite.visible = false
	black_overlay.visible = false
	visible = false
	is_showing = false

func apply_screen_shake():
	var camera = get_viewport().get_camera_3d()
	if camera:
		var original_pos = camera.position
		var tween = create_tween()
		for i in range(5):
			var offset = Vector3(randf_range(-1, 1), randf_range(-1, 1), 0) * shake_intensity
			tween.tween_property(camera, "position", original_pos + offset, shake_duration / 5)
		tween.tween_property(camera, "position", original_pos, shake_duration / 5)

# ========== 黑霧接近驚嚇 ==========
func fog_approach_jumpscare():
	black_overlay.visible = true
	black_overlay.modulate = Color(0, 0, 0, 0)
	
	var tween = create_tween()
	tween.tween_property(black_overlay, "modulate:a", 0.8, 0.5)
	tween.tween_interval(0.2)
	tween.tween_property(black_overlay, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): black_overlay.visible = false)
