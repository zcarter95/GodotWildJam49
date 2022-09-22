extends StaticBody2D


func _ready() -> void:
	var length: float = $CollisionShape2D.shape.extents.x
	$Left.position.x = -length + 8
	$Right.position.x = length - 8
	$Center.rect_position.x = -length + 16
	$Center.rect_size.x = length * 2 - 32
