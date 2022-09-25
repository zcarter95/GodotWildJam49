extends StaticBody2D


enum State {IDLE, ATTACK, DIE}

var target: KinematicBody2D
var state: int = State.IDLE

onready var sprite := $AnimatedSprite


func _on_PlayerDetector_body_entered(body: Node) -> void:
	if body.name == "Player":
		target = body
		state = State.ATTACK
		$Timer.start()
		sprite.play("Rise")


func _on_PlayerDetector_body_exited(body: Node) -> void:
	if body.name == "Player":
		target = null
		state = State.IDLE
		$Timer.stop()
		sprite.play("Idle")


func _on_Timer_timeout() -> void:
	$Attack.play()
	sprite.play("Attack")
	yield(get_tree().create_timer(0.5), "timeout")
	if sprite.flip_h:
		$AttackRight/CollisionShape2D.set_deferred("disabled", false)
	else:
		$AttackLeft/CollisionShape2D.set_deferred("disabled", false)
		


func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player" and not state == State.DIE:
		body.take_damage()


func _physics_process(_delta: float) -> void:
	if target:
		sprite.flip_h = global_position.x < target.global_position.x
	if sprite.flip_h:
		sprite.position = Vector2(33, -35)
	else:
		sprite.position = Vector2(-33, -35)


func _on_AnimatedSprite_animation_finished() -> void:
	if sprite.animation == "Attack":
		$AttackLeft/CollisionShape2D.set_deferred("disabled", true)
		$AttackRight/CollisionShape2D.set_deferred("disabled", true)
		sprite.play("Alert")


func _on_Die_body_entered(body: Node) -> void:
	if body.name == "Player" and body.global_position.y < $Die/CollisionShape2D.global_position.y:
		state = State.DIE
		$Timer.stop()
		hide()
		$Death.play()


func _on_Death_finished() -> void:
	queue_free()
