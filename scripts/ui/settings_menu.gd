extends Control

# ========== 節點引用 ==========
@onready var resolution_option = $SettingsContainer/GraphicsSection/ResolutionOption
@onready var fullscreen_toggle = $SettingsContainer/GraphicsSection/FullscreenToggle
@onready var quality_slider = $SettingsContainer/GraphicsSection/QualitySlider

@onready var master_volume = $SettingsContainer/AudioSection/MasterVolume
@onready var music_volume = $SettingsContainer/AudioSection/MusicVolume
@onready var sfx_volume = $SettingsContainer/AudioSection/SFXVolume

@onready var mic_device_option = $SettingsContainer/MicSection/MicDeviceOption
@onready var mic_volume_slider = $SettingsContainer/MicSection/MicVolumeSlider
@onready var audio_test_bar = $SettingsContainer/MicSection/AudioTestBar

@onready var apply_button = $ButtonContainer/ApplyButton
@onready var back_button = $ButtonContainer/BackButton

# ========== 初始化 ==========
func _ready():
	setup_resolution_options()
	setup_mic_devices()
	load_settings()
	connect_signals()

func setup_resolution_options():
	resolution_option.clear()
	var resolutions = [
		Vector2i(1920, 1080),
		Vector2i(1280, 720),
		Vector2i(1600, 900),
		Vector2i(2560, 1440)
	]
	for res in resolutions:
		resolution_option.add_item(str(res.x) + "x" + str(res.y))

func setup_mic_devices():
	mic_device_option.clear()
	var devices = AudioServer.get_input_device_list()
	for device in devices:
		mic_device_option.add_item(device)

func connect_signals():
	apply_button.pressed.connect(_on_apply_pressed)
	back_button.pressed.connect(_on_back_pressed)
	resolution_option.item_selected.connect(_on_resolution_changed)
	fullscreen_toggle.toggled.connect(_on_fullscreen_toggled)
	master_volume.value_changed.connect(_on_master_volume_changed)
	music_volume.value_changed.connect(_on_music_volume_changed)
	sfx_volume.value_changed.connect(_on_sfx_volume_changed)
	mic_device_option.item_selected.connect(_on_mic_device_changed)
	mic_volume_slider.value_changed.connect(_on_mic_volume_changed)

# ========== 設定處理 ==========
func _process(delta):
	update_audio_test()

func update_audio_test():
	if voice_manager:
		var level = voice_manager.get_mic_level()
		audio_test_bar.value = level * 100

func _on_resolution_changed(index: int):
	var resolutions = [Vector2i(1920, 1080), Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(2560, 1440)]
	if index < resolutions.size():
		DisplayServer.window_set_size(resolutions[index])

func _on_fullscreen_toggled(pressed: bool):
	if pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_master_volume_changed(value: float):
	AudioServer.set_bus_volume_db(0, value - 50)

func _on_music_volume_changed(value: float):
	AudioServer.set_bus_volume_db(1, value - 50)

func _on_sfx_volume_changed(value: float):
	AudioServer.set_bus_volume_db(2, value - 50)

func _on_mic_device_changed(index: int):
	var device_name = mic_device_option.get_item_text(index)
	AudioServer.input_device = device_name

func _on_mic_volume_changed(value: float):
	# 設定麥克風增益
	pass

# ========== 按鈕功能 ==========
func _on_apply_pressed():
	save_settings()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

# ========== 儲存/載入 ==========
func save_settings():
	var config = ConfigFile.new()
	config.set_value("graphics", "resolution_index", resolution_option.selected)
	config.set_value("graphics", "fullscreen", fullscreen_toggle.button_pressed)
	config.set_value("graphics", "quality", quality_slider.value)
	config.set_value("audio", "master", master_volume.value)
	config.set_value("audio", "music", music_volume.value)
	config.set_value("audio", "sfx", sfx_volume.value)
	config.set_value("mic", "device_index", mic_device_option.selected)
	config.set_value("mic", "volume", mic_volume_slider.value)
	config.save("user://settings.cfg")

func load_settings():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		resolution_option.selected = config.get_value("graphics", "resolution_index", 0)
		fullscreen_toggle.button_pressed = config.get_value("graphics", "fullscreen", false)
		quality_slider.value = config.get_value("graphics", "quality", 50)
		master_volume.value = config.get_value("audio", "master", 50)
		music_volume.value = config.get_value("audio", "music", 50)
		sfx_volume.value = config.get_value("audio", "sfx", 50)
		mic_device_option.selected = config.get_value("mic", "device_index", 0)
		mic_volume_slider.value = config.get_value("mic", "volume", 50)
