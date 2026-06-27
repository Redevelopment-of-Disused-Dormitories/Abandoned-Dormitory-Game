extends Node

# ========== 信號 ==========
signal game_started
signal game_over(victory: bool)
signal player_died(player_id: int)
signal relic_collected(count: int)
signal exorcism_completed

# ========== 遊戲狀態 ==========
enum GameState { LOBBY, PLAYING, GAME_OVER }
var current_state: GameState = GameState.LOBBY

# ========== 遊戲變數 ==========
var exorcism_count: int = 0
var total_relics: int = 7
var players_alive: Array = []
var players_ready: Dictionary = {}

# ========== 初始化 ==========
func _ready():
	current_state = GameState.LOBBY

# ========== 遊戲控制 ==========
func start_game():
	if current_state != GameState.LOBBY:
		return
	
	current_state = GameState.PLAYING
	exorcism_count = 0
	players_alive.clear()
	
	# 加入所有大廳成員
	for member in steam_manager.lobby_members:
		players_alive.append(member.id)
	
	print("[Game] 遊戲開始！玩家數: ", players_alive.size())
	game_started.emit()
	get_tree().change_scene_to_file("res://scenes/main/dormitory.tscn")

func end_game(victory: bool):
	current_state = GameState.GAME_OVER
	print("[Game] 遊戲結束！勝利: ", victory)
	game_over.emit(victory)

# ========== 玩家死亡 ==========
func on_player_died(player_id: int):
	if player_id in players_alive:
		players_alive.erase(player_id)
		print("[Game] 玩家死亡: ", player_id)
		player_died.emit(player_id)
		
		# 檢查是否全滅
		if players_alive.size() == 0:
			end_game(false)

# ========== 遺物收集 ==========
func collect_relic():
	exorcism_count += 1
	print("[Game] 收集遺物: ", exorcism_count, "/", total_relics)
	relic_collected.emit(exorcism_count)
	
	# 檢查是否收集完畢
	if exorcism_count >= total_relics:
		complete_exorcism()

func complete_exorcism():
	print("[Game] 7件遺物歸位！大門解鎖！")
	exorcism_completed.emit()
	end_game(true)

# ========== 準備系統 ==========
func set_player_ready(player_id: int, ready: bool):
	players_ready[player_id] = ready
	
	# 檢查是否所有人都準備好了
	var all_ready = true
	for member in steam_manager.lobby_members:
		if not players_ready.get(member.id, false):
			all_ready = false
			break
	
	if all_ready:
		start_game()

func check_all_mics_ready() -> bool:
	# 檢查所有玩家的麥克風狀態
	for member in steam_manager.lobby_members:
		# 這裡需要透過網路查詢其他人的麥克風狀態
		# 簡化版：只檢查自己
		if member.id == steam_manager.steam_id:
			if not voice_manager.has_microphone():
				return false
	return true
