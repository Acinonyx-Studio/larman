extends Control
@onready var audio_sources: OptionButton = $VBoxContainer/HBoxContainer2/AudioSources
@onready var alarm_buttons: HBoxContainer = $VBoxContainer/AlarmButtons


const ALARM_BUTTON = preload("res://alarmButton.tscn")
var path = "res://config.cfg"

const default_btns = '''[	{ "label": "Serviços Diversos", "color": "(0, 0.5, 0, 1)", "audioPath": "res://assets/audio1.wav" }, 
	{ "label": "Ambulância Urgente", "color": "(1, 1, 0, 1)", "audioPath": "res://assets/audio2.wav" },
	{ "label": "Acidente", "color": "(1, 0.647, 0, 1)", "audioPath": "res://assets/audio3.wav" },
	{ "label": "Fogo Florestal", "color": "(1, 0, 0, 1)", "audioPath": "res://assets/audio4.wav" },
	{ "label": "Fogo Urbano", "color": "(0.5, 0, 0, 1)", "audioPath": "res://assets/audio5.wav" }
]'''


func _ready() -> void:
	#save_config()
	load_config()
	list_audio_output_sources()
	

func save_config():
	var file = FileAccess.open(path,FileAccess.WRITE)
	var data = []
	for child in alarm_buttons.get_children():
		if child.is_in_group("alarm_btn"):
			data.append({
				"label": child.label,
				"color": str(child.color),
				"audioPath": child.audioPath
			})
	print(data)
	file.store_string(str(data))
	file = null
	
func load_config():
	var file
	if not FileAccess.file_exists(path):
		file = FileAccess.open(path,FileAccess.WRITE)
		file.store_string(default_btns)
		file.close()
	
	for child in alarm_buttons.get_children():
		child.queue_free()

	file = FileAccess.open(path, FileAccess.READ)
	var json_string = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_string)
	print(error, json_string)
	if error == OK:
		var data = json.get_data()
		print(data)
		for item in data:
			var alarm_button_instance = ALARM_BUTTON.instantiate()
			alarm_button_instance.text = item.label

			var color_components = item.color.substr(1, item.color.length() - 2).split(",")
			alarm_button_instance.color = Color(
				float(color_components[0]),
				float(color_components[1]),
				float(color_components[2]),
				float(color_components[3])
			)
			
			alarm_button_instance.audioPath = item.audioPath
			alarm_buttons.add_child(alarm_button_instance)
	
			
func list_audio_output_sources():
	var audio_drivers = AudioServer.get_output_device_list()
	for driver in audio_drivers:
		audio_sources.add_item(driver)
	audio_sources.connect("item_selected", Callable(self, "_on_audio_output_selected"))

func _on_audio_output_selected(index: int):
	var selected_device = AudioServer.get_output_device_list()[index]
	AudioServer.output_device = selected_device
	print("Selected audio output: ", selected_device)
