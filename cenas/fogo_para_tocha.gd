extends Area2D

func _ready() -> void:
	collision_layer = 1 << 4 # Power-up na Layer 5 collision_mask = 1 << 1 # Interagir com jogador na Layer 2
	collision_mask = 1 << 1


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body._recuperar_tocha(1)
		call_deferred("queue_free")
