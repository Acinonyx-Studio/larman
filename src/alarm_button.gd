extends HBoxContainer
@export var label: String = "Botão Alarme"
@export var color: Color = Color(0,0,0)
@export var audioPath: String = "res://assets/audio1.wav"
@export var announce: String = "res://assets/announce.wav"



@onready var file_select: Button = $FileSelect
@onready var button: Button = $Button

var parent


var asp = AudioStreamPlayer.new()
var ann_asp = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(asp)
	
	if audioPath.begins_with("res://"):
		asp.stream = load(audioPath)
	else:
		var file = FileAccess.open(audioPath, FileAccess.READ)
		if file:
			var stream
			var file_extension = audioPath.get_extension().to_lower()
			match file_extension:
				"wav":
					stream = AudioStreamWAV.new()
					stream.data = file.get_buffer(file.get_length())
				"mp3":
					stream = AudioStreamMP3.new()
					stream.data = file.get_buffer(file.get_length())
				"ogg":
					stream = AudioStreamOggVorbis.new()
					stream.data = file.get_buffer(file.get_length())
				_:
					parent.debug.text = "Unsupported audio format: " + file_extension
					file.close()
					return
			asp.stream = stream
			file.close()
		else:
			parent.debug.text = "Failed to open audio file: " + audioPath
	
	if not asp.stream:
		parent.debug.text = "Audio file not found or invalid: " + audioPath
		
	add_child(ann_asp)
	ann_asp.stream = load(announce)
	if not FileAccess.file_exists(announce):
		parent.debug.text = "audio file "+str(announce)+" not found"
		
	modulate = color
	ann_asp.connect("finished", Callable(self, "_on_AudioStreamPlayer_finished"))
	
	button.text = label
	
func _on_button_up() -> void:
	for child in parent.alarm_buttons.get_children():
		if child.is_in_group("alarm_btn"):
			child.asp.stop()
			child.ann_asp.stop()
	ann_asp.play()

func _on_AudioStreamPlayer_finished() -> void:
	asp.play()
