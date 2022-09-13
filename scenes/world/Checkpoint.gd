extends Area2D

func _ready():
	pass

func _on_animation_finished():
	$Display.animation = "Idle"

func _on_body_entered(body):
	if body.is_in_group("Player"):
		$Display.play()
		Progression.checkpoint = global_position
		print_debug(Progression.checkpoint)
		
		owner.CheckpointMark()
