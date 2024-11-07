extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body._recuperar_tocha(1)
		call_deferred("queue_free")
