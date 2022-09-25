extends Control


signal change_scene(to)
signal click

export var background_music: AudioStream


func _on_Back_pressed() -> void:
	emit_signal("click")
	emit_signal("change_scene", "res://scenes/title/title.tscn")
