extends Control

# ========== 節點引用 ==========
@onready var chat_input = $ChatInput
@onready var chat_display = $ChatDisplay
@onready var send_button = $SendButton

# ========== 變數 ==========
var is_chat_open := false
var message_history: Array = []

# ========== 初始化 ==========
func _ready():
	visible = false
	chat_input.text_submitted.connect(_on_message_sent)
	send_button.pressed.connect(_on_send_pressed)

func _input(event):
	# 按 T 開啟聊天
	if event.is_action_pressed("chat_toggle"):
		toggle_chat()

# ========== 聊天功能 ==========
func toggle_chat():
	is_chat_open = !is_chat_open
	visible = is_chat_open
	
	if is_chat_open:
		chat_input.grab_focus()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		chat_input.release_focus()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_message_sent(message: String):
	if message.strip_edges().is_empty():
		return
	
	send_message(message)
	chat_input.text = ""

func _on_send_pressed():
	_on_message_sent(chat_input.text)

func send_message(message: String):
	# 加入歷史記錄
	message_history.append({
		"sender": steam_manager.steam_name,
		"message": message,
		"time": Time.get_time_string_from_system()
	})
	
	# 顯示訊息
	add_chat_line(steam_manager.steam_name, message)
	
	# 透過 Steam 聊天發送
	steam_manager.send_lobby_chat(message)

func add_chat_line(sender: String, message: String):
	var timestamp = Time.get_time_string_from_system()
	var formatted = "[%s] %s: %s" % [timestamp, sender, message]
	chat_display.append_text(formatted + "\n")

func receive_message(sender_id: int, message: String):
	var sender_name = Steam.getFriendPersonaName(sender_id)
	add_chat_line(sender_name, message)

func add_system_message(message: String):
	chat_display.append_text("[系統] " + message + "\n")
