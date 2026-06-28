extends Control

@onready var player_list = $PlayerList
@onready var system_message = $SystemMessage
@onready var ready_button = $ButtonContainer/ReadyButton
@onready var start_button = $ButtonContainer/StartButton
@onready var chat_box = $ChatBox

var is_host := false
var players_ready: Dictionary = {}

func _ready():
	ready_button.pressed.connect(_on_ready_pressed)
	start_button.pressed.connect(_on_start_pressed)
	check_host_status()
	update_ui()

func check_host_status():
	is_host = true
	print("[Lobby] 房主狀態: ", is_host)

func update_ui():
	ready_button.visible = not is_host
	start_button.visible = is_host
	if is_host:
		start_button.disabled = false

func _on_ready_pressed():
	print("[Lobby] 準備按鈕點擊")

func _on_start_pressed():
	print("[Lobby] 開始遊戲")
	get_tree().change_scene_to_file("res://scenes/main/dormitory.tscn")

func add_chat_message(message: String):
	chat_box.append_text(message + "\n")

func show_system_message(message: String):
	system_message.text = message
