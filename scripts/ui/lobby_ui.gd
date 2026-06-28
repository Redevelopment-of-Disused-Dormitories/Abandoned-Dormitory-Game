extends Control

# ========== 節點引用 ==========
@onready var player_list = $PlayerList
@onready var system_message = $SystemMessage
@onready var ready_button = $ButtonContainer/ReadyButton
@onready var start_button = $ButtonContainer/StartButton
@onready var chat_box = $ChatBox

# ========== 變數 ==========
var is_host := false
var all_mics_ready := false
var players_ready: Dictionary = {}
var player_slot_scene = preload("res://scenes/ui/player_slot.tscn")

# ========== 初始化 ==========
func _ready():
	# 連接信號
	steam_manager.lobby_joined.connect(_on_lobby_joined)
	steam_manager.lobby_chat_message.connect(_on_chat_message)
	steam_manager.lobby_members_updated.connect(_on_members_updated)
	
	# 連接按鈕
	ready_button.pressed.connect(_on_ready_pressed)
	start_button.pressed.connect(_on_start_pressed)
	
	# 檢查是否為房主
	check_host_status()
	
	# 更新 UI
	update_ui()
	update_player_list()

func check_host_status():
	is_host = steam_manager.is_lobby_owner()
	print("[Lobby] 房主狀態: ", is_host)

# ========== UI 更新 ==========
func update_ui():
	ready_button.visible = not is_host
	start_button.visible = is_host
	
	# 檢查所有人的麥克風狀態
	all_mics_ready = check_all_mics_ready()
	
	# 更新按鈕狀態
	if is_host:
		start_button.disabled = not all_mics_ready or not all_players_ready()
	
	# 顯示警告
	if not all_mics_ready:
		show_system_message("⚠️ 系統提示：有玩家的通訊設備未就緒，無法啟動調查。")

func update_player_list():
	# 清空玩家列表
	for child in player_list.get_children():
		child.queue_free()
	
	# 加入所有玩家
	for member in steam_manager.lobby_members:
		var slot = player_slot_scene.instantiate()
		slot.setup(member)
		player_list.add_child(slot)

func _on_members_updated():
	update_player_list()
	update_ui()

# ========== 準備系統 ==========
func check_all_mics_ready() -> bool:
	for member in steam_manager.lobby_members:
		if member.id == steam_manager.steam_id:
			if not voice_manager.has_microphone():
				return false
	return true

func all_players_ready() -> bool:
	for member in steam_manager.lobby_members:
		if not players_ready.get(member.id, false):
			return false
	return true

func _on_ready_pressed():
	var my_id = steam_manager.steam_id
	players_ready[my_id] = not players_ready.get(my_id, false)
	
	# 通知其他玩家
	var msg = "READY" if players_ready[my_id] else "UNREADY"
	steam_manager.send_lobby_chat(msg)
	
	update_ui()

func _on_start_pressed():
	if all_mics_ready and all_players_ready():
		# 設定大廳為不可加入
		steam_manager.set_lobby_joinable(false)
		
		# 開始遊戲
		game_manager.start_game()

# ========== 聊天功能 ==========
func _on_chat_message(sender_id: int, message: String):
	var sender_name = "玩家"
	if steam_manager.steam_singleton:
		sender_name = steam_manager.steam_singleton.getFriendPersonaName(sender_id)
	add_chat_message(sender_name + ": " + message)
	
	# 處理準備狀態
	match message:
		"READY":
			players_ready[sender_id] = true
			update_ui()
		"UNREADY":
			players_ready[sender_id] = false
			update_ui()

func add_chat_message(message: String):
	chat_box.append_text(message + "\n")

# ========== 系統訊息 ==========
func show_system_message(message: String):
	system_message.text = message
	await get_tree().create_timer(3.0).timeout
	system_message.text = ""
