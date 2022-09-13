extends Node2D


export var start_time: int

onready var start_position: Vector2 = $Player.position


func _ready() -> void:
	for checkpoint in $Checkpoints.get_children():
		if checkpoint.has_signal("checkpoint_reached"):
			checkpoint.connect("checkpoint_reached", self, "on_checkpoint_reached")
	

func _process(delta: float) -> void:
	$CanvasLayer/Control/Time.text = "%.2f" % $Timer.time_left


func on_checkpoint_reached(checkpoint: Area2D) -> void:
	$Timer.stop()
	$Timer.wait_time = checkpoint.time
	$Timer.start()
