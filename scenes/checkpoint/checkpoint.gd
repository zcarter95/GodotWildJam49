extends Area2D


signal checkpoint_reached(this)

export var time: float
export var is_final := false
export var is_active := false


func _ready() -> void:
	if is_final:
		$AudioStreamPlayer2D.stream = load("res://scenes/checkpoint/FinalCheckpoint.wav")
		$Display.frames = load("res://scenes/checkpoint/checklast_frames.tres")
	$Display.play("Idle")


func _on_animation_finished():
	$Display.animation = "Idle"


func _on_body_entered(body):
	if body.is_in_group("player") and not is_active:
		is_active = true
		for other_checkpoint in get_tree().get_nodes_in_group("checkpoint"):
			if not other_checkpoint == self:
				other_checkpoint.is_active = false
		$Display.play("Activate")
		$AudioStreamPlayer2D.play()
		emit_signal("checkpoint_reached", self)
