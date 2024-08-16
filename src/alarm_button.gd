extends Button
@export var label: String = "Botão Alarme"
@export var color: Color = Color(0,0,0)
@export var audioPath: String = "res://assets/audio1.wav"
@export var announce: String = "res://assets/announce.wav"

var parent


var asp = AudioStreamPlayer.new()
var ann_asp = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(asp)
	
	asp.stream = load(audioPath)
	if not FileAccess.file_exists(audioPath):
		parent.debug.text = "audio file "+str(audioPath)+" not found"
		
	add_child(ann_asp)
	ann_asp.stream = load(announce)
	if not FileAccess.file_exists(announce):
		parent.debug.text = "audio file "+str(announce)+" not found"
		
	modulate = color
	ann_asp.connect("finished", Callable(self, "_on_AudioStreamPlayer_finished"))
	


func _on_button_up() -> void:
	for child in parent.alarm_buttons.get_children():
		if child.is_in_group("alarm_btn"):
			child.asp.stop()
			child.ann_asp.stop()
	ann_asp.play()
	#asp.play()

func _on_AudioStreamPlayer_finished() -> void:
	asp.play()
