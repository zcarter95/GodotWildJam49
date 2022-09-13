extends Node


const TWEEN_TIME := 0.5

var cur_scene: Node
var checkpoint := -1
var to: String
var transition: bool
var reset_checkpoint: bool


func _ready() -> void:
	change_scene("res://scenes/title/title.tscn", false)


func change_scene(t: String, tr := true, rc := true) -> void:
	to = t
	transition = tr
	reset_checkpoint = rc
	if transition:
		$Tween.interpolate_property($CanvasLayer/ColorRect.material, "shader_param/position", 1, -1.5, TWEEN_TIME)
		$Tween.start()
	else:
		call_deferred("change_scene_deferred")


func checkpoint_reached(id: int) -> void:
	checkpoint = id


func respawn() -> void:
	change_scene(cur_scene.filename, true, false)


func _on_Tween_tween_all_completed() -> void:
	if to:
		change_scene_deferred()


func change_scene_deferred() -> void:
	if cur_scene:
		cur_scene.free()
	cur_scene = load(to).instance()
	to = ""
	add_child(cur_scene)
	if cur_scene.has_signal("change_scene"):
		cur_scene.connect("change_scene", self, "change_scene")
	if cur_scene is Level:
		cur_scene.connect("checkpoint_reached", self, "checkpoint_reached")
		cur_scene.connect("respawn", self, "respawn")
		if reset_checkpoint:
			checkpoint = -1
			cur_scene.spawn_at_start()
		else:
			cur_scene.spawn_at_checkpoint(checkpoint)
	if transition:
		$Tween.interpolate_property($CanvasLayer/ColorRect.material, "shader_param/position", -1.5, 1, TWEEN_TIME)
		$Tween.start()
	
