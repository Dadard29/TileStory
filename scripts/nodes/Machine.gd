extends Node2D

onready var anim = $Animations
onready var loading_sound = $Sounds/LoadingSound
onready var win_sound = $Sounds/WinSound

const ANIMATION_LOADING = "loading"

func play_loading():
	if anim.get_animation() != ANIMATION_LOADING or not anim.is_playing():
		anim.play(ANIMATION_LOADING)
	
	if not loading_sound.is_playing():
		loading_sound.play()

func _on_Animations_animation_finished() -> void:
	if anim.get_animation() == ANIMATION_LOADING:
		# win
		if loading_sound.is_playing():
			loading_sound.stop()

		if not win_sound.is_playing():
			win_sound.play()
