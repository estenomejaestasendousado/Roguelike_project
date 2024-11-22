extends Node2D
@onready var node_2d: Node2D = $"."
var rotation_speed = 1.0  # Valor menor para rotação mais lenta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	node_2d.rotate(rotation_speed * delta)
