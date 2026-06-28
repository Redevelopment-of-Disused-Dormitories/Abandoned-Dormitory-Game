extends Node

# ========== 設定 ==========
@export var max_health: float = 100.0
@export var max_sanity: float = 100.0
@export var sanity_drain_near_fog: float = 5.0
@export var health_regen_rate: float = 1.0

# ========== 變數 ==========
var current_health: float = 100.0
var current_sanity: float = 100.0
var is_alive := true
var is_near_fog := false

# ========== 信號 ==========
signal health_changed(level: float)
signal sanity_changed(level: float)
signal player_damaged(damage: float)
signal player_healed(amount: float)
signal sanity_low
signal player_died

func _process(delta):
	# 健康回復
	if current_health < max_health:
		current_health += health_regen_rate * delta
		current_health = min(current_health, max_health)
		health_changed.emit(current_health)
	
	# 理智消耗（靠近黑霧時）
	if is_near_fog:
		current_sanity -= sanity_drain_near_fog * delta
		current_sanity = max(current_sanity, 0.0)
		sanity_changed.emit(current_sanity)
		
		if current_sanity <= 30:
			sanity_low.emit()
		
		if current_sanity <= 0:
			die()

func take_damage(damage: float):
	if not is_alive:
		return
	
	current_health -= damage
	current_health = max(current_health, 0.0)
	health_changed.emit(current_health)
	player_damaged.emit(damage)
	
	if current_health <= 0:
		die()

func heal(amount: float):
	current_health += amount
	current_health = min(current_health, max_health)
	health_changed.emit(current_health)
	player_healed.emit(amount)

func reduce_sanity(amount: float):
	current_sanity -= amount
	current_sanity = max(current_sanity, 0.0)
	sanity_changed.emit(current_sanity)
	
	if current_sanity <= 30:
		sanity_low.emit()

func die():
	if not is_alive:
		return
	
	is_alive = false
	player_died.emit()
	game_manager.on_player_died(steam_manager.steam_id)

func respawn():
	is_alive = true
	current_health = max_health
	current_sanity = max_sanity
	health_changed.emit(current_health)
	sanity_changed.emit(current_sanity)

func set_near_fog(near: bool):
	is_near_fog = near
