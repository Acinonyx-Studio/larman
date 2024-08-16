extends Button
@export var label: String = "Botão Alarme"
@export var color: Color = Color(0,0,0)
@export var audioPath: String = "res://assets/audio1.wav"

var parent

var asp = AudioStreamPlayer.new()


func _ready() -> void:
	add_child(asp)
	asp.stream = load(audioPath)
	if not FileAccess.file_exists(audioPath):
		parent.debug.text = "audio file "+str(audioPath)+" not found"
	modulate = color
	


func _on_button_up() -> void:
	for child in parent.alarm_buttons.get_children():
		if child.is_in_group("alarm_btn"):
			child.asp.stop()
		asp.play()

