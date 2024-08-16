extends Button
@export var label: String = "Botão Alarme"
@export var color: Color = Color(0,0,0)
@export var audioPath: String = "res://assets/audio1.wav"

var asp = AudioStreamPlayer.new()
var parent

func _ready() -> void:
	add_child(asp)
	asp.stream = load(audioPath)
	parent = get_parent()
	modulate = color
	


func _on_button_up() -> void:
	for child in parent.get_children():
		if child.is_in_group("alarm_btn"):
			child.asp.stop()
		asp.play()
