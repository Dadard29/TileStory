extends Node2D

onready var _jump_sound = $JumpSound
onready var _energy_gain_sound = $EnergyGainSound
onready var _death_sound = $DeathSound
onready var _spawn_sound = $SpawnSound
onready var _music = $Music

func jump():
	if not _jump_sound.is_playing():
		_jump_sound.play()

func energy_gain():
	if not _energy_gain_sound.is_playing():
		_energy_gain_sound.play()
	
func death():
	if not _death_sound.is_playing():
		_death_sound.play()

func spawn():
	if not _spawn_sound.is_playing():
		_spawn_sound.play()

func _ready() -> void:
	pass
