extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var letter_display_timer = $LetterDisplayTimer
#@onready var label = $MarginContainer/RichTextLabel
@onready var next_indicator = $NinePatchRect/Control2/NextIndicator


const MAX_WIDTH = 256

var shake_text = "[shake rate=20.0 level=5 connected=1]%s[/shake]"
var text = ""
var letter_index = 0
var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2
var body = null

signal finished_displaying


func _ready():
	scale = Vector2.ZERO


func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display

	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)

	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	
	#if get_parent() is Player:
		#pass
		#position.x -= size.x / 2
		#position.y -= size.y + 24
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	
	
	label.text = ""
	
	pivot_offset = Vector2(size.x / 2, size.y)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.15).set_trans(Tween.TRANS_BACK)
	
	_display_letter()


func _display_letter():
	label.text += text[letter_index]

	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		next_indicator.visible = true
		return

	match text[letter_index]:
		"!", ".", ",", "?":
			letter_display_timer.start(punctuation_time)
		" ":
			letter_display_timer.start(space_time)
		_:
			letter_display_timer.start(letter_time)

			var pitch = randf_range(.6, .8)
			if text[letter_index] in ["a", "e", "i", "o", "u"]:
				pitch += .2
			
			SoundManager.play_speech_sound(pitch)


func _on_letter_display_timer_timeout():
	_display_letter()
