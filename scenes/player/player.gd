extends KinematicBody2D


signal died

enum State {DEFAULT, DEAD}

export var max_speed := 200
export var acceleration := 1_200
export var friction := 1_000
export var gravity := 1_200
export var jump_force := 400

var HALF_SCREEN_HEIGHT: int = ProjectSettings.get_setting("display/window/size/height") / 2
var velocity := Vector2()
var state: int = State.DEFAULT

onready var cam := $Camera2D


func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return
	var input := Input.get_axis("move_left", "move_right")
	if input == 0.0:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
	else:
		velocity.x = move_toward(velocity.x, input * max_speed, acceleration * delta)
	velocity.y += gravity * delta
	if is_on_floor() and Input.is_action_pressed("move_up"):
		velocity.y = -jump_force
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if global_position.y + HALF_SCREEN_HEIGHT < cam.limit_bottom:
		cam.limit_bottom = global_position.y + HALF_SCREEN_HEIGHT
	elif global_position.y - HALF_SCREEN_HEIGHT > cam.limit_bottom:
		state = State.DEAD
		emit_signal("died")
