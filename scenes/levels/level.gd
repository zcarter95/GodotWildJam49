extends Node2D
class_name Level


signal checkpoint_reached(id)
signal respawn()
signal change_scene(to)
signal click

export var start_with_timer := true
export(String, FILE, "*.tscn") var next_scene: String
export var background_music: AudioStream

onready var start_position: Vector2 = $Player.position


func _ready() -> void:
	if not start_with_timer:
		$CanvasLayer/Control/Time.hide()
	for checkpoint in $Checkpoints.get_children():
		if checkpoint.has_signal("checkpoint_reached"):
			checkpoint.connect("checkpoint_reached", self, "on_checkpoint_reached")


func _process(_delta: float) -> void:
	$CanvasLayer/Control/Time.text = "%.2f" % $Timer.time_left


func spawn_at_checkpoint(id: int) -> void:
	var checkpoint := $Checkpoints.get_child(id)
	$Timer.wait_time = checkpoint.time
	$Player.position = checkpoint.position
	$Timer.start()
	$Player/Camera2D.reset_smoothing()


func spawn_at_start() -> void:
	if start_with_timer:
		$Timer.start()


func on_checkpoint_reached(checkpoint: Area2D) -> void:
	$CanvasLayer/Control/Time.show()
	$Timer.stop()
	$Timer.wait_time = checkpoint.time
	$Timer.start()
	emit_signal("checkpoint_reached", checkpoint.get_index())
	if checkpoint.is_final:
		$CanvasLayer/Control/Comp.show()


func _on_Timer_timeout() -> void:
	emit_signal("respawn")


func _on_Player_died() -> void:
	emit_signal("respawn")


func _on_NextLevel_body_entered(body: Node) -> void:
	if body.name == "Player":
		emit_signal("change_scene", next_scene)


func _on_Death_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.die()


func _on_Settings_pressed() -> void:
	emit_signal("click")
	Settings.show_settings()
