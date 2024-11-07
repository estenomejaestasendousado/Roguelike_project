extends Area2D

func _ready() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.recuperar_vida(20)
		call_deferred("queue_free")  # Remove o power-up de forma segura
