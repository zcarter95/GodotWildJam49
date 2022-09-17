extends Area2D


signal checkpoint_reached(this)

export var time: float


func _on_animation_finished():
	$Display.animation = "Idle"


func _on_body_entered(body):
	if body.is_in_group("player"):
		$Display.play("Activate")
		emit_signal("checkpoint_reached", self)
