extends SpotLight3D

# ========== 設定 ==========
@export var max_battery: float = 100.0
@export var drain_rate: float = 2.0
@export var recharge_rate: float = 1.0
@export var flicker_threshold: float = 20.0

# ========== 變數 ==========
var current_battery: float = 100.0
var is_on := false
var can_recharge := true

# ========== 信號 ==========
signal battery_changed(level: float)
signal battery_empty
signal flashlight_toggled(on: bool)

func _process(delta):
	if is_on:
		drain_battery(delta)
	elif can_recharge:
		recharge_battery(delta)

func drain_battery(delta: float):
	current_battery -= drain_rate * delta
	current_battery = max(current_battery, 0.0)
	battery_changed.emit(current_battery)
	
	# 閃爍效果
	if current_battery <= flicker_threshold:
		apply_flicker()
	
	# 電量耗盡
	if current_battery <= 0:
		turn_off()
		battery_empty.emit()

func recharge_battery(delta: float):
	if current_battery < max_battery:
		current_battery += recharge_rate * delta
		current_battery = min(current_battery, max_battery)
		battery_changed.emit(current_battery)

func apply_flicker():
	var flicker = randf_range(0.3, 1.0)
	light_energy = flicker

func turn_on():
	if current_battery > 0:
		is_on = true
		visible = true
		light_energy = 1.5
		flashlight_toggled.emit(true)
		audio_manager.play_sfx("flashlight_on")

func turn_off():
	is_on = false
	visible = false
	flashlight_toggled.emit(false)
	audio_manager.play_sfx("flashlight_off")

func toggle():
	if is_on:
		turn_off()
	else:
		turn_on()

func add_battery(amount: float):
	current_battery = min(current_battery + amount, max_battery)
	battery_changed.emit(current_battery)
