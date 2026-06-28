extends Control

# ========== 節點引用 ==========
@onready var host_dialog = $HostDialog
@onready var room_name_input = $HostDialog/VBoxContainer/RoomNameInput
@onready var password_input = $HostDialog/VBoxContainer/PasswordInput
@onready var voice_status = $VoiceStatus
@onready var host_button = $MainVBox/ButtonContainer/HostButton
@onready var browse_button = $MainVBox/ButtonContainer/BrowseButton
@onready var settings_button = $MainVBox/ButtonContainer/SettingsButton
@onready var quit_button = $MainVBox/ButtonContainer/QuitButton

# ========== 初始化 ==========
func _ready():
	# 連接信號
	steam_manager.lobby_created.connect(_on_lobby_created)
	steam_manager.steam_initialized.connect(_on_steam_ready)
	
	# 檢查麥克風
	update_voice_status()
	
	# 初始化按鈕
	host_button.pressed.connect(_on_host_pressed)
	browse_button.pressed.connect(_on_browse_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# 初始化對話框
	host_dialog.confirmed.connect(_on_host_confirmed)

func _on_steam_ready():
	voice_status.update_status(true)

func update_voice_status():
	var has_mic = voice_manager.has_microphone()
	voice_status.update_status(has_mic)

# ========== 按鈕功能 ==========
func _on_host_pressed():
	# 顯示創建房間對話框（不阻擋）
	host_dialog.popup_centered()
	room_name_input.text = steam_manager.steam_name + " 的宿舍"
	password_input.text = ""
	
	# 如果沒有麥克風，顯示警告
	if not voice_manager.has_microphone():
		show_message("⚠️ 警告：未偵測到麥克風。遊戲需要麥克風才能開始。")

func _on_host_confirmed():
	var room_name = room_name_input.text
	var password = password_input.text
	
	# 設定大廳資料
	steam_manager.set_lobby_data("name", room_name)
	if password != "":
		steam_manager.set_lobby_data("password", password)
	
	# 建立大廳
	steam_manager.create_lobby(Steam.LobbyType.LOBBY_TYPE_PUBLIC, 7)

func _on_lobby_created(lobby_id: int):
	# 跳轉到大廳等待畫面
	get_tree().change_scene_to_file("res://scenes/ui/lobby.tscn")

func _on_browse_pressed():
	# 顯示伺服器列表（不阻擋）
	get_tree().change_scene_to_file("res://scenes/ui/server_browser.tscn")
	
	# 如果沒有麥克風，顯示警告
	if not voice_manager.has_microphone():
		show_message("⚠️ 警告：未偵測到麥克風。遊戲需要麥克風才能開始。")

func _on_settings_pressed():
	# 顯示設定選單
	get_tree().change_scene_to_file("res://scenes/ui/settings.tscn")

func _on_quit_pressed():
	# 關閉遊戲
	get_tree().quit()

# ========== 工具函數 ==========
func show_message(text: String):
	# 顯示訊息給玩家
	print("[UI] ", text)
	# TODO: 顯示 UI 訊息框
