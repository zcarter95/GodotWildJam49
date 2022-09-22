extends Control


signal change_scene(to)

const TWEEN_TIME := 0.5


func _on_Start_pressed() -> void:
	emit_signal("change_scene", "res://scenes/levels/tutorial/tutorial.tscn")


func _on_Credits_pressed() -> void:
	if $Tween.is_active():
		return
	$Tween.interpolate_property($VBox, "rect_position:y", 0, -360, TWEEN_TIME)
	$Tween.start()


func _on_Back_pressed() -> void:
	if $Tween.is_active():
		return
	$Tween.interpolate_property($VBox, "rect_position:y", -360, 0, TWEEN_TIME)
	$Tween.start()

