extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var canvas_modulate = CanvasModulate.new()
	canvas_modulate.color = Color(0.7, 0.7, 0.7, 1)  # Ajuste para a cor desejada
	add_child(canvas_modulate)
