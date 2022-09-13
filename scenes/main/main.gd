extends Node


var cur_scene: Node
var checkpoint := -1


func _ready() -> void:
	call_deferred("change_scene", "res://scenes/title/title.tscn")


func change_scene(to: String, reset_checkpoint := true) -> void:
	if reset_checkpoint:
		checkpoint = -1
	if cur_scene:
		cur_scene.free()
	cur_scene = load(to).instance()
	add_child(cur_scene)
	if cur_scene.has_signal("change_scene"):
		cur_scene.connect("change_scene", self, "change_scene", [], CONNECT_DEFERRED)
	if cur_scene is Level:
		cur_scene.connect("checkpoint_reached", self, "checkpoint_reached")
		cur_scene.connect("respawn", self, "respawn")
		if not checkpoint == -1:
			cur_scene.spawn_at_checkpoint(checkpoint)
		else:
			cur_scene.spawn_at_start()


func checkpoint_reached(id: int) -> void:
	checkpoint = id


func respawn() -> void:
	call_deferred("change_scene", cur_scene.filename, false)
