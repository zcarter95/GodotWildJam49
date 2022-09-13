extends Node2D

onready var starter = $Checkpoint1

func _enter_tree():
	if Progression.checkpoint:
		$Player.global_position = Progression.checkpoint

func _ready():
	pass

func _on_Player_died() -> void:
	$CanvasLayer/Control/GameOver.show()


func _on_Restart_pressed() -> void:
	get_tree().reload_current_scene()
