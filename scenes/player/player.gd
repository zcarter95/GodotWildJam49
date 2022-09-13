extends KinematicBody2D


signal died

enum State {DEFAULT, DEAD, DASH}

export var max_speed := 200
export var acceleration := 1_200
export var friction := 1_000
export var gravity := 1_200
export var jump_force := 400
export var max_jumps := 2
export var dash_speed := 400

var HALF_SCREEN_HEIGHT: int = ProjectSettings.get_setting("display/window/size/height") / 2
var velocity := Vector2()
var state: int = State.DEFAULT
var jump_num := 0
var dash_left: bool

onready var cam := $Camera2D
onready var animatedSprite := $AnimatedSprite


func _physics_process(delta: float) -> void:
	match state:
		State.DEFAULT:
			var input := Input.get_axis("move_left", "move_right")
			if input == 0.0:
				velocity.x = move_toward(velocity.x, 0.0, friction * delta)
				if is_on_floor():
					animatedSprite.animation = "Idle"
			else:
				velocity.x = move_toward(velocity.x, input * max_speed, acceleration * delta)
				if is_on_floor():
					animatedSprite.animation = "Run"
			
			if is_on_floor():
				jump_num = 0
			velocity.y += gravity * delta
			if jump_num < max_jumps and Input.is_action_just_pressed("move_up"):
				velocity.y = -jump_force
				jump_num += 1
			velocity = move_and_slide(velocity, Vector2.UP)
			
			if global_position.y + HALF_SCREEN_HEIGHT < cam.limit_bottom:
				cam.limit_bottom = global_position.y + HALF_SCREEN_HEIGHT
			elif global_position.y - HALF_SCREEN_HEIGHT > cam.limit_bottom:
				state = State.DEAD
				emit_signal("died")
				
			var is_jumping := false
			var is_falling := false 
			if !is_on_floor() and velocity.y <= 0:
				is_jumping = true
			elif !is_on_floor() and velocity.y >= 0:
				is_falling = true
				
			if is_jumping:
				animatedSprite.animation = "Jump"
			if is_falling:
				animatedSprite.animation = "Fall"
			flip_sprite(velocity.x)
		State.DASH:
			if dash_left:
				move_and_slide(Vector2.LEFT * dash_speed, Vector2.UP)
			else:
				move_and_slide(Vector2.RIGHT * dash_speed, Vector2.UP)


func _unhandled_input(event: InputEvent) -> void:
	match state:
		State.DEFAULT:
			if event.is_action_pressed("dash"):
				state = State.DASH
				dash_left = animatedSprite.flip_h
				$Dash.start()


func flip_sprite(velocity_x: float) -> void:
	if velocity_x < 0:
		animatedSprite.flip_h = true
	elif velocity_x > 0: 
		animatedSprite.flip_h = false


func _on_Dash_timeout() -> void:
	if state == State.DASH:
		state = State.DEFAULT
