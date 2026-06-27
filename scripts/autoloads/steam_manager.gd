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

# ========== 初始化 ==========
func _ready():
	init_steam()

func init_steam():
	var result: Dictionary = Steam.steamInitEx(false)
	print("[Steam] Init Result: ", result)
	
	if result.status == 0:
		steam_id = Steam.getSteamID()
		steam_name = Steam.getPersonaName()
		print("[Steam] 成功: ", steam_name, " (", steam_id, ")")
		steam_initialized.emit()
	else:
		push_error("[Steam] 初始化失敗: " + str(result.verbal))

func _process(delta):
	Steam.run_callbacks()

# ========== 大廳功能 ==========
func create_lobby(lobby_type: int, max_members: int) -> void:
	print("[Steam] 建立大廳...")
	Steam.createLobby(lobby_type, max_members)

func _on_lobby_created(result: int, lobby_id: int) -> void:
	if result == 1:
		current_lobby_id = lobby_id
		Steam.setLobbyData(lobby_id, "name", steam_name + " 的宿舍")
		Steam.setLobbyData(lobby_id, "version", "1.0")
		print("[Steam] 大廳建立成功: ", lobby_id)
		lobby_created.emit(lobby_id)
	else:
		push_error("[Steam] 大廳建立失敗")

func join_lobby(lobby_id: int) -> void:
	print("[Steam] 加入大廳: ", lobby_id)
	Steam.joinLobby(lobby_id)

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
	if current_lobby_id != 0:
		Steam.leaveLobby(current_lobby_id)
		print("[Steam] 離開大廳: ", current_lobby_id)
		current_lobby_id = 0

# ========== 大廳成員 ==========
func update_lobby_members() -> void:
	lobby_members.clear()
	var count = Steam.getNumLobbyMembers(current_lobby_id)
	
	for i in range(count):
		var member_id = Steam.getLobbyMemberByIndex(current_lobby_id, i)
		var member_name = Steam.getFriendPersonaName(member_id)
		lobby_members.append({
			"id": member_id,
			"name": member_name
		})
	
	print("[Steam] 更新成員列表: ", lobby_members.size(), " 人")
	lobby_members_updated.emit()

func get_lobby_member_count() -> int:
	return Steam.getNumLobbyMembers(current_lobby_id)

func is_lobby_owner() -> bool:
	var owner_id = Steam.getLobbyOwner(current_lobby_id)
	return owner_id == steam_id

# ========== 大廳設定 ==========
func set_lobby_joinable(joinable: bool) -> void:
	Steam.setLobbyJoinable(current_lobby_id, joinable)

func set_lobby_data(key: String, value: String) -> void:
	Steam.setLobbyData(current_lobby_id, key, value)

func get_lobby_data(key: String) -> String:
	return Steam.getLobbyData(current_lobby_id, key)

# ========== 搜尋大廳 ==========
func get_lobby_list() -> void:
	Steam.addRequestLobbyListDistanceFilter(Steam.LobbyDistanceFilter.LOBBY_DISTANCE_FILTER_COUNTRYWIDE)
	Steam.requestLobbyList()

func _on_lobby_match_list(lobbies: Array) -> void:
	print("[Steam] 找到 ", lobbies.size(), " 個大廳")
	for lobby_id in lobbies:
		var lobby_name = Steam.getLobbyData(lobby_id, "name")
		var member_count = Steam.getNumLobbyMembers(lobby_id)
		print("  - ", lobby_name, " (", member_count, "/7)")

# ========== 聊天功能 ==========
func send_lobby_chat(message: String) -> void:
	Steam.sendLobbyChatMsg(current_lobby_id, message)

func _on_lobby_chat_msg(user_id: int, _chat_type: int, message_id: int) -> void:
	var message = Steam.getLobbyChatEntry(message_id)
	print("[Steam] 聊天: ", user_id, " - ", message)
	lobby_chat_message.emit(user_id, message)
