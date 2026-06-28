extends Control

# ========== 設定 ==========
@export var total_time: float = 600.0
@export var warning_time: float = 120.0

# ========== 節點引用 ==========
@onready var timer_label = $TimerLabel
@onready var warning_flash = $WarningFlash

# ========== 變數 ==========
var remaining_time: float = 600.0
var is_running := false
var warning_triggered := false

# ========== 信號 ==========
signal timer_updated(time_left: float)
signal timer_warning
signal timer_expired

func _ready():
	remaining_time = total_time
	update_display()

func _process(delta):
	if is_running and remaining_time > 0:
		remaining_time -= delta
		remaining_time = max(remaining_time, 0.0)
		update_display()
		timer_updated.emit(remaining_time)
		
		# 警告時間
		if remaining_time <= warning_time and not warning_triggered:
			warning_triggered = true
			timer_warning.emit()
			trigger_warning()
		
		# 時間到
		if remaining_time <= 0:
			timer_expired.emit()
			stop()

func update_display():
	var minutes = int(remaining_time) / 60
	var seconds = int(remaining_time) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]
	
	# 最後 60 秒變紅色
	if remaining_time <= 60:
		timer_label.modulate = Color.RED
	elif remaining_time <= warning_time:
		timer_label.modulate = Color.YELLOW
	else:
		timer_label.modulate = Color.WHITE

func trigger_warning():
	if warning_flash:
		warning_flash.visible = true
		var tween = create_tween()
		for i in range(3):
			tween.tween_property(warning_flash, "modulate:a", 1.0, 0.2)
			tween.tween_property(warning_flash, "modulate:a", 0.0, 0.2)
		tween.tween_callback(func(): warning_flash.visible = false)

func start():
	is_running = true

func stop():
	is_running = false

func reset():
	remaining_time = total_time
	warning_triggered = false
	update_display()

func add_time(seconds: float):
	remaining_time += seconds
	remaining_time = min(remaining_time, total_time)
	update_display()
