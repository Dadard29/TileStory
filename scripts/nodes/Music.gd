extends AudioStreamPlayer

export(bool) var muted = false

func toggle_music_mute():
	muted = not muted
	if muted and is_playing():
		set_stream_paused(true)
	else:
		set_stream_paused(false)

func _ready() -> void:
	play()
