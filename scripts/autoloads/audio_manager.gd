extends Node

# ========== 信號 ==========
signal sfx_played(sfx_name: String)
signal music_played(music_name: String)

# ========== 節點引用 ==========
@onready var sfx_player = $SFXPlayer
@onready var music_player = $MusicPlayer
@onready var ambient_player = $AmbientPlayer

# ========== 音效檔案 ==========
var sfx_files: Dictionary = {
	"relic_collected": "res://assets/audio/sfx/relic_collected.wav",
	"door_open": "res://assets/audio/sfx/door_open.wav",
	"door_close": "res://assets/audio/sfx/door_close.wav",
	"gate_open": "res://assets/audio/sfx/gate_open.wav",
	"power_restore": "res://assets/audio/sfx/power_restore.wav",
	"flashlight_on": "res://assets/audio/sfx/flashlight_on.wav",
	"flashlight_off": "res://assets/audio/sfx/flashlight_off.wav",
	"footstep": "res://assets/audio/sfx/footstep.wav",
	"fog_ambient": "res://assets/audio/sfx/fog_ambient.wav",
	"heartbeat": "res://assets/audio/sfx/heartbeat.wav"
}

var music_files: Dictionary = {
	"lobby": "res://assets/audio/music/lobby.ogg",
	"gameplay": "res://assets/audio/music/gameplay.ogg",
	"victory": "res://assets/audio/music/victory.ogg",
	"defeat": "res://assets/audio/music/defeat.ogg",
	"retro_military": "res://assets/audio/music/retro_military.ogg"
}

# ========== 初始化 ==========
func _ready():
	setup_players()

func setup_players():
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "SFX"
	add_child(sfx_player)
	
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	ambient_player = AudioStreamPlayer.new()
	ambient_player.bus = "Ambient"
	add_child(ambient_player)

# ========== 音效播放 ==========
func play_sfx(sfx_name: String):
	if not sfx_files.has(sfx_name):
		push_warning("[AudioManager] 找不到音效: " + sfx_name)
		return
	
	var stream = load(sfx_files[sfx_name])
	if stream:
		sfx_player.stream = stream
		sfx_player.play()
		sfx_played.emit(sfx_name)

func play_music(music_name: String):
	if not music_files.has(music_name):
		push_warning("[AudioManager] 找不到音樂: " + music_name)
		return
	
	var stream = load(music_files[music_name])
	if stream:
		music_player.stream = stream
		music_player.play()
		music_played.emit(music_name)

func stop_music():
	music_player.stop()

func set_music_volume(volume_db: float):
	music_player.volume_db = volume_db

func set_sfx_volume(volume_db: float):
	sfx_player.volume_db = volume_db

# ========== 環境音效 ==========
func play_ambient(ambient_name: String):
	var file_path = "res://assets/audio/ambient/" + ambient_name + ".ogg"
	var stream = load(file_path)
	if stream:
		ambient_player.stream = stream
		ambient_player.play()

func stop_ambient():
	ambient_player.stop()
