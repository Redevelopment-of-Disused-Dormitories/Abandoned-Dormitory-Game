extends Node

# ========== 信號 ==========
signal voice_data_received(sender_id: int, audio_data: PackedByteArray)

# ========== 變數 ==========
var is_recording := false
var voice_sample_rate: int = 24000
var voice_player: AudioStreamPlayer

# ========== 初始化 ==========
func _ready():
	voice_player = AudioStreamPlayer.new()
	add_child(voice_player)
	setup_audio_player()

func setup_audio_player():
	var stream = AudioStreamGenerator.new()
	stream.mix_rate = voice_sample_rate
	voice_player.stream = stream
	voice_player.play()

# ========== 錄音控制 ==========
func start_recording():
	is_recording = true
	Steam.startVoiceRecording()
	Steam.setInGameVoiceSpeaking(steam_manager.steam_id, true)
	print("[Voice] 開始錄音")

func stop_recording():
	is_recording = false
	Steam.stopVoiceRecording()
	Steam.setInGameVoiceSpeaking(steam_manager.steam_id, false)
	print("[Voice] 停止錄音")

func toggle_recording():
	if is_recording:
		stop_recording()
	else:
		start_recording()

# ========== 語音處理 ==========
func _process(delta):
	if is_recording:
		check_and_send_voice()

func check_and_send_voice():
	var available = Steam.getAvailableVoice()
	
	if available.result == Steam.VoiceResult.VOICE_RESULT_OK:
		if available.size > 0:
			var voice_data = Steam.getVoice()
			
			if voice_data.result == Steam.VoiceResult.VOICE_RESULT_OK:
				if voice_data.size > 0:
					send_voice_to_others(voice_data.buffer)

func send_voice_to_others(audio_data: PackedByteArray):
	if multiplayer.has_multiplayer_peer():
		_rpc_send_voice(audio_data)

@rpc("any_peer", "reliable")
func _rpc_send_voice(audio_data: PackedByteArray):
	var sender_id = multiplayer.get_remote_sender_id()
	voice_data_received.emit(sender_id, audio_data)
	process_received_voice(audio_data)

func process_received_voice(audio_data: PackedByteArray):
	var decompressed = Steam.decompressVoice(audio_data, voice_sample_rate)
	
	if decompressed.result == Steam.VoiceResult.VOICE_RESULT_OK:
		var playback = voice_player.get_stream_playback()
		if playback == null:
			return
		
		var frames = PackedVector2Array()
		frames.resize(decompressed.size / 2)
		
		for i in range(0, decompressed.size, 2):
			var sample = decompressed.uncompressed.decode_s16(i)
			var amplitude = float(sample) / 32768.0
			frames[i / 2] = Vector2(amplitude, amplitude)
		
		var available = playback.get_frames_available()
		if available >= frames.size():
			playback.push_buffer(frames)
		elif available > 0:
			playback.push_buffer(frames.slice(0, available))

# ========== 音量偵測 ==========
func get_mic_level() -> float:
	if not steam_manager or steam_manager.steam_id == 0:
		return 0.0
	var available = Steam.getAvailableVoice()
	if available.result == Steam.VoiceResult.VOICE_RESULT_OK:
		return clamp(float(available.size) / 2048.0, 0.0, 1.0)
	return 0.0

func has_microphone() -> bool:
	if not steam_manager or steam_manager.steam_id == 0:
		return false
	var available = Steam.getAvailableVoice()
	return available.result == Steam.VoiceResult.VOICE_RESULT_OK
