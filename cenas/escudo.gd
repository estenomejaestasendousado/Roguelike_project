extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_mask = 1 << 1
	collision_layer = 1 << 4

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.recuparar_escudo(20)
		call_deferred("queue_free")  # Remove o power-up de forma segura
