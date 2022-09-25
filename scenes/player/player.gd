extends KinematicBody2D


signal died
signal damage(health)

enum State {DEFAULT, DEAD, DASH}

export var max_speed := 200
export var acceleration := 1_200
export var friction := 1_000
export var gravity := 1_200
export var jump_force := 400
export var max_jumps := 2
export var dash_speed := 400
export var wall_jump_speed := 200

var HALF_SCREEN_HEIGHT: int = ProjectSettings.get_setting("display/window/size/height") / 2
var velocity := Vector2()
var state: int = State.DEFAULT
var jump_num := 0
var dash_left: bool
var can_dash := true
var health := 3

onready var cam := $Camera2D
onready var sprite := $AnimatedSprite


func _ready() -> void:
	sprite.playing = true


func _physics_process(delta: float) -> void:
	match state:
		State.DEFAULT:
			var input := Input.get_axis("move_left", "move_right")
			if input == 0.0:
				velocity.x = move_toward(velocity.x, 0.0, friction * delta)
			else:
				velocity.x = move_toward(velocity.x, input * max_speed, acceleration * delta)
			
			if is_on_floor() or is_on_wall():
				jump_num = 0
				can_dash = true
			velocity.y += gravity * delta
			if jump_num < max_jumps and Input.is_action_just_pressed("move_up"):
				if is_on_wall():
					play_sound("WallJump")
					velocity.x = wall_jump_speed if sprite.flip_h else -wall_jump_speed
				elif jump_num > 0:
					play_sound("DoubleJump")
				else:
					play_sound("Jump")
				velocity.y = -jump_force
				jump_num += 1
			velocity = move_and_slide(velocity, Vector2.UP)
				
			if is_on_floor():
				if input == 0:
					sprite.play("Idle")
				else:
					sprite.play("Run")
					var footstep_playing := false
					for child in get_children():
						if child is AudioStreamPlayer2D and child.stream and "Footstep" in child.stream.resource_path:
							footstep_playing = true
							break
					if not footstep_playing:
						play_sound("Footstep%s" % (randi() % 2 + 1))
			else:
				if velocity.y < 0 and jump_num == 1:
					sprite.play("Jump")
				elif velocity.y < 0 and jump_num == 2:
					sprite.play("DoubleJump")
				else:
					sprite.play("Fall")
			if not input == 0:
				sprite.flip_h = input < 0
				
		State.DASH:
			sprite.play("Dash")
			if dash_left:
				velocity = move_and_slide(Vector2.LEFT * dash_speed, Vector2.UP)
			else:
				velocity = move_and_slide(Vector2.RIGHT * dash_speed, Vector2.UP)


func _unhandled_input(event: InputEvent) -> void:
	match state:
		State.DEFAULT:
			if event.is_action_pressed("dash") and can_dash:
				can_dash = false
				state = State.DASH
				dash_left = sprite.flip_h
				$Dash.start()
				play_sound("Dash")


func _on_Dash_timeout() -> void:
	if state == State.DASH:
		state = State.DEFAULT


func play_sound(sound: String) -> void:
	var a := AudioStreamPlayer2D.new()
	a.stream = load("res://scenes/player/%s.wav" % sound)
	add_child(a)
	a.connect("finished", a, "queue_free")
	a.play()


func die() -> void:
	play_sound("PlayerDeath")
	emit_signal("died")
	

func take_damage() -> void:
	health -= 1
	emit_signal("damage", health)
	if health == 0:
		die()
