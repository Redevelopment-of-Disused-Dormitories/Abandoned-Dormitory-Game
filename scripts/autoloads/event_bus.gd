extends Node

# ========== 遊戲事件 ==========
signal power_restored
signal all_relics_collected
signal player_entered_room(room_name: String)
signal noise_detected(position: Vector3, intensity: float)

# ========== UI 事件 ==========
signal show_message(text: String)
signal hide_message

# ========== 玩家事件 ==========
signal player_spawned(player_id: int)
signal player_died(player_id: int)
signal player_respawned(player_id: int)
