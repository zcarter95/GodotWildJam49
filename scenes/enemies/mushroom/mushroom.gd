extends StaticBody2D


enum State {IDLE, ATTACK, DIE}

var target: KinematicBody2D
var state: int = State.IDLE

onready var raycast := $RayCast2D


func _on_PlayerDetector_body_entered(body: Node) -> void:
	if body.name == "Player":
		target = body
		state = State.ATTACK
		$Timer.start()
		$AnimatedSprite.play("Rise")


func _on_PlayerDetector_body_exited(body: Node) -> void:
	if body.name == "Player":
		target = null
		state = State.IDLE
		$Timer.stop()
		$AnimatedSprite.play("Idle")


func _on_Timer_timeout() -> void:
	$AnimatedSprite.play("Attack")
	yield(get_tree().create_timer(0.5), "timeout")
	if $AnimatedSprite.flip_h:
		$AttackRight/CollisionShape2D.set_deferred("disabled", false)
	else:
		$AttackLeft/CollisionShape2D.set_deferred("disabled", false)
		


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player" and not state == State.DIE:
		body.die()


func _physics_process(_delta: float) -> void:
	if target:
		$AnimatedSprite.flip_h = global_position.x < target.global_position.x
	if raycast.is_colliding():
		if raycast.get_collider().name == "Player" and raycast.get_collider().global_position.y < raycast.global_position.y:
			state = State.DIE
			queue_free()


func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "Attack":
		$AttackLeft/CollisionShape2D.set_deferred("disabled", true)
		$AttackRight/CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite.play("Alert")
