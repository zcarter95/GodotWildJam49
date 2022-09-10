extends Node2D



func _on_Player_died() -> void:
	$CanvasLayer/Control/GameOver.show()


func _on_Restart_pressed() -> void:
	get_tree().reload_current_scene()
