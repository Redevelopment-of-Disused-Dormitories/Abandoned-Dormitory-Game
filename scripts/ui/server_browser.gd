extends Control

# ========== 節點引用 ==========
@onready var server_list = $ServerList/ServerListContainer
@onready var refresh_button = $RefreshButton
@onready var back_button = $BackButton

# ========== 初始化 ==========
func _ready():
	refresh_button.pressed.connect(_on_refresh_pressed)
	back_button.pressed.connect(_on_back_pressed)
	refresh_server_list()

# ========== 伺服器列表 ==========
func refresh_server_list():
	# 清空列表
	for child in server_list.get_children():
		child.queue_free()
	
	# 請求大廳列表
	steam_manager.get_lobby_list()

func _on_lobby_match_list(lobbies: Array):
	for lobby_id in lobbies:
		var lobby_name = "未知房間"
		var member_count = 0
		if steam_manager.steam_singleton:
			lobby_name = steam_manager.steam_singleton.getLobbyData(lobby_id, "name")
			member_count = steam_manager.steam_singleton.getNumLobbyMembers(lobby_id)
		add_server_entry(lobby_id, lobby_name, member_count)

func add_server_entry(lobby_id: int, name: String, players: int):
	var entry = PanelContainer.new()
	entry.custom_minimum_size = Vector2(500, 60)
	
	var hbox = HBoxContainer.new()
	entry.add_child(hbox)
	
	var name_label = Label.new()
	name_label.text = name
	name_label.custom_minimum_size = Vector2(200, 0)
	hbox.add_child(name_label)
	
	var players_label = Label.new()
	players_label.text = str(players) + "/7 人"
	players_label.custom_minimum_size = Vector2(80, 0)
	hbox.add_child(players_label)
	
	var join_button = Button.new()
	join_button.text = "加入"
	join_button.pressed.connect(_on_join_pressed.bind(lobby_id))
	hbox.add_child(join_button)
	
	server_list.add_child(entry)

func _on_join_pressed(lobby_id: int):
	steam_manager.join_lobby(lobby_id)

# ========== 按鈕功能 ==========
func _on_refresh_pressed():
	refresh_server_list()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
