extends Node2D

signal dialogue_finished

const TEXT_BOX = preload("res://scenes/TextBox.tscn")

var dialogue_lines: Array[String] = []
var current_line_index = 0
var text_box
var text_box_position: Vector2
var is_dialogue_active = false
var can_advance_line = false


func _unhandled_input(event):
	if event.is_action_pressed("interact") and is_dialogue_active and can_advance_line:
		if is_instance_valid(text_box):
			text_box.queue_free()

		current_line_index += 1
		if current_line_index >= dialogue_lines.size():
			is_dialogue_active = false
			current_line_index = 0
			dialogue_finished.emit()
			return
		
		_show_text_box()


func start_passive_dialogue(pos: Vector2, lines: Array[String]):
	if is_dialogue_active:
		return

	dialogue_lines = lines
	text_box_position = pos
	_show_text_box(get_tree().get_first_node_in_group("Player"))
	
	is_dialogue_active = true
	
	await get_tree().create_timer(1 + .1 * lines[0].length()).timeout
	if is_instance_valid(text_box):
		text_box.queue_free()
	is_dialogue_active = false
	current_line_index = 0
	dialogue_finished.emit()


func start_dialogue(pos: Vector2, lines: Array[String]):
	if is_dialogue_active:
		return

	dialogue_lines = lines
	text_box_position = pos
	_show_text_box()
	
	is_dialogue_active = true

func _show_text_box(body = null):
	#if body is Player:
		##body.text_box = text_box
		##body.text_box.position = to_local(text_box_position)
		#body.text_box.finished_displaying.connect(_on_text_box_finished_displaying)
		#body.text_box.display_text(dialogue_lines[current_line_index])
	#else:
	text_box = TEXT_BOX.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	text_box.global_position = text_box_position
	get_tree().root.add_child(text_box)
	text_box.display_text(dialogue_lines[current_line_index])
	can_advance_line = false


func _on_text_box_finished_displaying():
	can_advance_line = true
