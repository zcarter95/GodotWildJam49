extends Node2D

onready var starter = $Checkpoint1

func _enter_tree():
	if Progression.checkpoint:
		$Player.global_position = Progression.checkpoint

func _on_Player_died() -> void:
	$CanvasLayer/Control/GameOver.show()

func _process(delta) -> void:
	$Label.text = String($Timer.time_left)


func _on_Restart_pressed() -> void:
	get_tree().reload_current_scene()

func CheckpointMark():
	$Timer.start()

func _on_Timer_timeout():
	_on_Player_died() #I call the function here to prevent redundant code.
