extends Node2D

onready var starter = $Checkpoint1

func _ready():
	
	if position in Progression.checkpoint:
		$Player.position = Progression.checkpoint.position

func _on_Player_died() -> void:
	$CanvasLayer/Control/GameOver.show()


func _on_Restart_pressed() -> void:
	get_tree().reload_current_scene()
