extends CharacterBody3D

# ========== 設定 ==========
@export var speed: float = 3.0
@export var stun_duration: float = 2.0
@export var detection_range: float = 15.0
@export var noise_threshold: float = 0.6

# ========== 節點引用 ==========
@onready var nav_agent = $NavigationAgent3D
@onready var particles = $GPUParticles3D
@onready var detection_area = $DetectionArea

# ========== 變數 ==========
var target_position: Vector3
var is_stunned := false
var is_chasing := false
var wander_timer: float = 0.0
var wander_interval: float = 3.0

# ========== 初始化 ==========
func _ready():
	# 加入黑霧群組
	add_to_group("fog_ai")
	
	# 設定偵測區域
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.area_entered.connect(_on_area_entered)

func _physics_process(delta):
	if is_stunned:
		return
	
	if is_chasing and target_position:
		navigate_to_target()
	else:
		wander(delta)

# ========== 導航 ==========
func navigate_to_target():
	nav_agent.target_position = target_position
	
	if nav_agent.is_navigation_finished():
		return
	
	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func wander(delta):
	wander_timer += delta
	
	if wander_timer >= wander_interval:
		wander_timer = 0.0
		# 隨機選擇一個巡邏點
		var random_offset = Vector3(randf_range(-10, 10), 0, randf_range(-10, 10))
		target_position = global_position + random_offset
		is_chasing = false

# ========== 聽覺偵測 ==========
func on_noise_event(noise_position: Vector3, noise_level: float):
	if is_stunned:
		return
	
	if noise_level >= noise_threshold:
		target_position = noise_position
		is_chasing = true
		print("[Fog] 偵測到噪音，開始追蹤: ", noise_position)

func _on_body_entered(body):
	if body.is_in_group("players"):
		# 碰到玩家 → 造成傷害
		if body.has_method("die"):
			body.die()

func _on_area_entered(area):
	# 偵測手電筒射線
	if area.is_in_group("flashlight_beam"):
		stun()

# ========== 僵直 ==========
func stun():
	if is_stunned:
		return
	
	is_stunned = true
	velocity = Vector3.ZERO
	
	# 暫停粒子
	if particles:
		particles.emitting = false
	
	print("[Fog] 被手電筒照到，僵直 ", stun_duration, " 秒")
	
	await get_tree().create_timer(stun_duration).timeout
	
	is_stunned = false
	
	# 恢復粒子
	if particles:
		particles.emitting = true

# ========== 追蹤大門 ==========
func attract_to_gate():
	var gate = get_tree().get_first_node_in_group("main_gate")
	if gate:
		target_position = gate.global_position
		is_chasing = true
		speed *= 1.5  # 加速追蹤
