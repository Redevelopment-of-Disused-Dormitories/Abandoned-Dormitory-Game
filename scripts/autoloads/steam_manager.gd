extends Node

# ========== 信號 ==========
signal steam_initialized
signal lobby_created(lobby_id: int)
signal lobby_joined(lobby_id: int)
signal lobby_join_failed
signal lobby_chat_message(sender_id: int, message: String)
signal lobby_members_updated

# ========== 變數 ==========
var steam_id: int = 0
var steam_name: String = ""
var current_lobby_id: int = 0
var lobby_members: Array = []
var is_steam_available: bool = false
var steam_singleton = null

# ========== 初始化 ==========
func _ready():
	init_steam()

func init_steam():
	if Engine.has_singleton("Steam"):
		steam_singleton = Engine.get_singleton("Steam")
		var result: Dictionary = steam_singleton.steamInitEx(false)
		print("[Steam] Init Result: ", result)
		
		if result.status == 0:
			steam_id = steam_singleton.getSteamID()
			steam_name = steam_singleton.getPersonaName()
			is_steam_available = true
			print("[Steam] 成功: ", steam_name, " (", steam_id, ")")
		else:
			steam_name = "離線玩家"
			print("[Steam] 初始化失敗")
	else:
		steam_name = "離線玩家"
		print("[Steam] 不可用，使用離線模式")
	
	steam_initialized.emit()

func _process(_delta):
	if is_steam_available and steam_singleton:
		steam_singleton.run_callbacks()

# ========== 大廳功能 ==========
func create_lobby(lobby_type: int, max_members: int) -> void:
	if not is_steam_available or not steam_singleton:
		print("[Steam] 離線模式：模擬建立大廳")
		lobby_created.emit(0)
		return
	
	print("[Steam] 建立大廳...")
	steam_singleton.createLobby(lobby_type, max_members)

func _on_lobby_created(result: int, lobby_id: int) -> void:
	if result == 1:
		current_lobby_id = lobby_id
		steam_singleton.setLobbyData(lobby_id, "name", steam_name + " 的宿舍")
		steam_singleton.setLobbyData(lobby_id, "version", "1.0")
		print("[Steam] 大廳建立成功: ", lobby_id)
		lobby_created.emit(lobby_id)
	else:
		print("[Steam] 大廳建立失敗")

func join_lobby(lobby_id: int) -> void:
	if not is_steam_available or not steam_singleton:
		print("[Steam] 離線模式：無法加入大廳")
		lobby_join_failed.emit()
		return
	
	print("[Steam] 加入大廳: ", lobby_id)
	steam_singleton.joinLobby(lobby_id)

func _on_lobby_joined(lobby_id: int, _permissions: int, _locked: bool, result: int) -> void:
	if result == 1:
		current_lobby_id = lobby_id
		update_lobby_members()
		print("[Steam] 已加入大廳: ", lobby_id)
		lobby_joined.emit(lobby_id)
	else:
		print("[Steam] 加入大廳失敗")
		lobby_join_failed.emit()

func leave_lobby() -> void:
	if current_lobby_id != 0 and steam_singleton:
		steam_singleton.leaveLobby(current_lobby_id)
		print("[Steam] 離開大廳: ", current_lobby_id)
		current_lobby_id = 0

# ========== 大廳成員 ==========
func update_lobby_members() -> void:
	lobby_members.clear()
	if not steam_singleton:
		return
	
	var count = steam_singleton.getNumLobbyMembers(current_lobby_id)
	for i in range(count):
		var member_id = steam_singleton.getLobbyMemberByIndex(current_lobby_id, i)
		var member_name = steam_singleton.getFriendPersonaName(member_id)
		lobby_members.append({"id": member_id, "name": member_name})
	
	print("[Steam] 更新成員列表: ", lobby_members.size(), " 人")
	lobby_members_updated.emit()

func get_lobby_member_count() -> int:
	if steam_singleton:
		return steam_singleton.getNumLobbyMembers(current_lobby_id)
	return 0

func is_lobby_owner() -> bool:
	if steam_singleton:
		var owner_id = steam_singleton.getLobbyOwner(current_lobby_id)
		return owner_id == steam_id
	return true

# ========== 大廳設定 ==========
func set_lobby_joinable(joinable: bool) -> void:
	if steam_singleton:
		steam_singleton.setLobbyJoinable(current_lobby_id, joinable)

func set_lobby_data(key: String, value: String) -> void:
	if steam_singleton:
		steam_singleton.setLobbyData(current_lobby_id, key, value)

func get_lobby_data(key: String) -> String:
	if steam_singleton:
		return steam_singleton.getLobbyData(current_lobby_id, key)
	return ""

# ========== 搜尋大廳 ==========
func get_lobby_list() -> void:
	if not is_steam_available or not steam_singleton:
		print("[Steam] 離線模式：無法搜尋大廳")
		return
	
	steam_singleton.addRequestLobbyListDistanceFilter(3)
	steam_singleton.requestLobbyList()

func _on_lobby_match_list(lobbies: Array) -> void:
	print("[Steam] 找到 ", lobbies.size(), " 個大廳")

# ========== 聊天功能 ==========
func send_lobby_chat(message: String) -> void:
	if steam_singleton:
		steam_singleton.sendLobbyChatMsg(current_lobby_id, message)

func _on_lobby_message(_lobby_id: int, user_id: int, message: String, _chat_type: int) -> void:
	print("[Steam] 聊天: ", user_id, " - ", message)
	lobby_chat_message.emit(user_id, message)
