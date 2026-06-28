extends Node

var sfx_player: AudioStreamPlayer
var music_player: AudioStreamPlayer
var ambient_player: AudioStreamPlayer

func _ready():
	sfx_player = AudioStreamPlayer.new()
	sfx_player.name = "SFXPlayer"
	add_child(sfx_player)
	
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	add_child(music_player)
	
	ambient_player = AudioStreamPlayer.new()
	ambient_player.name = "AmbientPlayer"
	add_child(ambient_player)

func play_sfx(sfx_name: String):
	print("[Audio] 播放音效: ", sfx_name)

func play_music(music_name: String):
	print("[Audio] 播放音樂: ", music_name)

func stop_music():
	if music_player:
		music_player.stop()

func set_music_volume(volume_db: float):
	if music_player:
		music_player.volume_db = volume_db

func set_sfx_volume(volume_db: float):
	if sfx_player:
		sfx_player.volume_db = volume_db
