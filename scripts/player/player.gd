extends CharacterBody3D

# ========== 設定 ==========
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.002

# ========== 引用 ==========
@onready var camera = $Camera3D
@onready var flashlight = $Hand/Flashlight
@onready var interaction_ray = $InteractionRay
@onready var voice_player = $VoicePlayer

# ========== 變數 ==========
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_alive := true
var flashlight_on := false

# ========== 初始化 ==========
func _ready():
	# 只控制本地玩家
	if not is_multiplayer_authority():
		camera.current = false
		return
	
	camera.current = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# 設定互動射線
	interaction_ray.target_position = Vector3(0, 0, -3)

func _unhandled_input(event):
	if not is_multiplayer_authority():
		return
	
	if not is_alive:
		return
	
	# 視角轉動
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		camera.rotation.x -= event.relative.y * MOUSE_SENSITIVITY
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _physics_process(delta):
	if not is_multiplayer_authority():
		return
	
	if not is_alive:
		return
	
	# 重力
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# 跳躍
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# 移動方向
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func _process(_delta):
	if not is_multiplayer_authority():
		return
	
	# 手電筒開關
	if Input.is_action_just_pressed("flashlight"):
		toggle_flashlight()
	
	# 互動
	if Input.is_action_just_pressed("interact"):
		try_interact()

# ========== 手電筒 ==========
func toggle_flashlight():
	flashlight_on = not flashlight_on
	flashlight.visible = flashlight_on

# ========== 互動 ==========
func try_interact():
	if interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		if collider.has_method("interact"):
			collider.interact.rpc()

# ========== 死亡 ==========
func die():
	if not is_alive:
		return
	
	is_alive = false
	visible = false
	
	# 通知遊戲管理器
	game_manager.on_player_died(steam_manager.steam_id)
	
	# 切換到觀戰模式
	# TODO: 實作 CCTV 觀戰

func respawn():
	is_alive = true
	visible = true
	global_position = Vector3(0, 1, 0)
