extends CanvasLayer


signal change_scene
signal click

const PATH := "user://settings.ini"

var config: ConfigFile


func _ready() -> void:
	config = ConfigFile.new()
	if config.load(PATH) == OK:
		var sound = config.get_value("audio", "sound", 1.0)
		if sound is float:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), linear2db(sound))
			$PopupPanel/VBoxContainer/HBoxContainer2/Sound.value = sound
		else:
			config.set_value("audio", "sound", 1.0)
		var music = config.get_value("audio", "music", 1.0)
		if music is float:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(music))
			$PopupPanel/VBoxContainer/HBoxContainer3/Music.value = music
		else:
			config.set_value("audio", "music", 1.0)
		config.save(PATH)


func show_settings(can_quit := true) -> void:
	get_tree().paused = true
	$PopupPanel/VBoxContainer/Quit.visible = can_quit
	$PopupPanel.popup_centered()


func _on_PopupPanel_popup_hide() -> void:
	get_tree().paused = false


func _on_Sound_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), linear2db(value))
	config.set_value("audio", "sound", value)
	config.save(PATH)


func _on_Music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(value))
	config.set_value("audio", "music", value)
	config.save(PATH)


func _on_Quit_pressed() -> void:
	emit_signal("click")
	$PopupPanel.hide()
	emit_signal("change_scene", "res://scenes/title/title.tscn")


func _on_Keybinds_pressed() -> void:
	emit_signal("click")
	Keybinds.show_keybinds()
