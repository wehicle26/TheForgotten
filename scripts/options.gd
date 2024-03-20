extends Control

@onready var master_volume_slider = $ButtonContainer/MasterVolumeSlider
@onready var music_volume_slider = $ButtonContainer/MusicVolumeSlider
@onready var sfx_volume_slider = $ButtonContainer/SfxVolumeSlider

var ui = "res://scenes/Ui.tscn"
var master: FmodBus
var music: FmodBus
var fx: FmodBus

func _ready():
	master = FmodServer.get_bus("bus:/")
	music = FmodServer.get_bus("bus:/Music")
	fx = FmodServer.get_bus("bus:/Fx")
	master_volume_slider.value = GlobalState.master_volume
	music_volume_slider.value = GlobalState.music_volume
	sfx_volume_slider.value = GlobalState.sfx_volume

func _on_back_button_pressed():
	SoundManager.play_custom_sound(null, "event:/ui_release", 0.2)
	GlobalState.master_volume = master_volume_slider.value
	get_tree().change_scene_to_file(ui)


func _on_back_button_mouse_entered():
	SoundManager.play_custom_sound(null, "event:/ui_hover", 0.2)


func _on_master_volume_slider_value_changed(value):
	master.volume = value


func _on_music_volume_slider_value_changed(value):
	music.volume = value


func _on_sfx_volume_slider_value_changed(value):
	fx.volume = value

