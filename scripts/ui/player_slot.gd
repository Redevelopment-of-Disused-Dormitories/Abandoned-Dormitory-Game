extends PanelContainer

@onready var player_name = $HBoxContainer/PlayerName
@onready var mic_icon = $HBoxContainer/MicIcon
@onready var ready_status = $HBoxContainer/ReadyStatus

func setup(member_data: Dictionary):
	player_name.text = member_data.name
	mic_icon.text = "🎤"
	ready_status.text = "未準備"
	ready_status.modulate = Color.RED

func update_talking(talking: bool):
	if talking:
		mic_icon.modulate = Color.GREEN
		mic_icon.scale = Vector2(1.2, 1.2)
	else:
		mic_icon.modulate = Color.WHITE
		mic_icon.scale = Vector2(1.0, 1.0)

func update_ready(ready: bool):
	if ready:
		ready_status.text = "已準備"
		ready_status.modulate = Color.GREEN
	else:
		ready_status.text = "未準備"
		ready_status.modulate = Color.RED
