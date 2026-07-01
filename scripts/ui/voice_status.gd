extends PanelContainer

@onready var mic_icon = $HBoxContainer/MicIcon
@onready var audio_meter = $HBoxContainer/AudioMeter
@onready var status_label = $StatusLabel

func _process(_delta):
	update_display()

func update_display():
	if voice_manager:
		var level = voice_manager.get_mic_level()
		audio_meter.value = level * 100
		
		if level > 0.1:
			mic_icon.modulate = Color.GREEN
		else:
			mic_icon.modulate = Color.WHITE

func update_status(has_mic: bool):
	if has_mic:
		status_label.text = "🟢 通訊已連線：可以開始調查"
		status_label.modulate = Color.GREEN
	else:
		status_label.text = "🔴 錯誤：未偵測到麥克風輸入"
		status_label.modulate = Color.RED
