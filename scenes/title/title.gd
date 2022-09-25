extends Control


signal change_scene(to)
signal click

export var background_music: AudioStream

const TWEEN_TIME := 0.5


func _on_Start_pressed() -> void:
	emit_signal("click")
	emit_signal("change_scene", "res://scenes/levels/tutorial.tscn")


func _on_Credits_pressed() -> void:
	emit_signal("click")
	if $Tween.is_active():
		return
	$Tween.interpolate_property($VBox, "rect_position:y", 0, -360, TWEEN_TIME)
	$Tween.start()


func _on_Back_pressed() -> void:
	emit_signal("click")
	if $Tween.is_active():
		return
	$Tween.interpolate_property($VBox, "rect_position:y", -360, 0, TWEEN_TIME)
	$Tween.start()


func _on_Settings_pressed() -> void:
	emit_signal("click")
	Settings.show_settings(false)
