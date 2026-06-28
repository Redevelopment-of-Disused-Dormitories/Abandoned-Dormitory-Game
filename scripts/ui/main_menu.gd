extends Control

@onready var host_dialog = $HostDialog
@onready var voice_status = $VoiceStatus

func _ready():
	print("[MainMenu] 主選單載入完成")

func _on_host_pressed():
	print("[MainMenu] 點擊：創立宿舍伺服器")
	host_dialog.popup_centered()

func _on_host_confirmed():
	print("[MainMenu] 對話框確認，跳轉到大廳")
	get_tree().change_scene_to_file("res://scenes/ui/lobby.tscn")

func _on_browse_pressed():
	print("[MainMenu] 點擊：尋找探險隊伍")
	get_tree().change_scene_to_file("res://scenes/ui/server_browser.tscn")

func _on_settings_pressed():
	print("[MainMenu] 點擊：調節配備")
	get_tree().change_scene_to_file("res://scenes/ui/settings.tscn")

func _on_quit_pressed():
	print("[MainMenu] 點擊：離開調查")
	get_tree().quit()
