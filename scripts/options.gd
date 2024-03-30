extends Control

@onready var master_volume_slider = $ButtonContainer/MasterVolumeSlider
@onready var music_volume_slider = $ButtonContainer/MusicVolumeSlider
@onready var sfx_volume_slider = $ButtonContainer/SfxVolumeSlider
@onready var option_button = $ButtonContainer/HBoxContainer/OptionButton as OptionButton
@onready var option_button2 = $ButtonContainer/HBoxContainer2/OptionButton as OptionButton

const RESOLUTION: Dictionary = {
	"1920x1080": Vector2i(1920, 1080),
	"1280x720": Vector2i(1280, 720)
}

const WINDOW_MODE: Array[String] = [
	"Borderless",
	"Fullscreen",
	"Windowed",
]

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
	option_button.item_selected.connect(_on_window_mode_selected)
	option_button2.item_selected.connect(_on_resolution_selected)
	add_window_mode_items()
	add_resolution_items()


func add_resolution_items():
	for res in RESOLUTION:
		option_button2.add_item(res)


func _on_resolution_selected(index: int):
	DisplayServer.window_set_size(RESOLUTION.values()[index])


func add_window_mode_items():
	for window_mode in WINDOW_MODE:
		option_button.add_item(window_mode)


func _on_window_mode_selected(index: int):
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)


func _on_back_button_pressed():
	SoundManager.play_custom_sound(null, "event:/ui_release", 0.2)
	GlobalState.master_volume = master_volume_slider.value
	GlobalState.music_volume = music_volume_slider.value
	GlobalState.sfx_volume = sfx_volume_slider.value
	if not GlobalState.game_running:
		get_tree().change_scene_to_file(ui)
	else:
		get_parent().unpause()


func _on_back_button_mouse_entered():
	SoundManager.play_custom_sound(null, "event:/ui_hover", 0.2)


func _on_master_volume_slider_value_changed(value):
	master.volume = value


func _on_music_volume_slider_value_changed(value):
	music.volume = value


func _on_sfx_volume_slider_value_changed(value):
	fx.volume = value

