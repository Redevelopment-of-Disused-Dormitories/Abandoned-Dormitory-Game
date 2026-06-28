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
	# 連接按鈕
	host_button.pressed.connect(_on_host_pressed)
	browse_button.pressed.connect(_on_browse_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	# 初始化對話框
	host_dialog.confirmed.connect(_on_host_confirmed)
	
	print("[MainMenu] 主選單載入完成")

# ========== 按鈕功能 ==========
func _on_host_pressed():
	print("[MainMenu] 點擊：創立宿舍伺服器")
	host_dialog.popup_centered()

func _on_host_confirmed():
	print("[MainMenu] 對話框確認，跳轉到大廳")
	# 直接跳轉到大廳
	get_tree().change_scene_to_file("res://scenes/ui/lobby.tscn")

func _on_browse_pressed():
	print("[MainMenu] 點擊：尋找探險隊伍")
	get_tree().change_scene_to_file("res://scenes/ui/server_browser.tscn")

func _on_settings_pressed():
	print("[MainMenu] 點擊：調節配備")
	get_tree().change_scene_to_file("res://scenes/ui/settings.tscn")

func _on_quit_pressed():
	print("[MainMenu] 點擊：離開調查")
	get_tree().quit()

# ========== 工具函數 ==========
func show_message(text: String):
	print("[UI] ", text)
