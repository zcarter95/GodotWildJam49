extends StaticBody2D


export var move_dist: float
export var move_dir: Vector2
export var move_speed: float

var dir := true
onready var start := position


func _ready() -> void:
	move_dir = move_dir.normalized()
	var length: float = $CollisionShape2D.shape.extents.x
	$Left.position.x = -length + 8
	$Right.position.x = length - 8
	$Center.rect_position.x = -length + 16
	$Center.rect_size.x = length * 2 - 32


func _physics_process(delta: float) -> void:
	if start.distance_to(position) > move_dist / 2:
		dir = not dir
	if dir:
		position += move_dir * delta * move_speed
	else:
		position -= move_dir * delta * move_speed
		
