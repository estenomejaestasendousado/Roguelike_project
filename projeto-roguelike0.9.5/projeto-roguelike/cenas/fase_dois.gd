extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var canvas_modulate = CanvasModulate.new()
	canvas_modulate.color = Color(0.2, 0.2, 0.2, 0.9)  # Ajuste para a cor desejada
	add_child(canvas_modulate)
