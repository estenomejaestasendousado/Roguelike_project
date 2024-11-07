extends Area2D

func _ready() -> void:
	collision_layer = 1<<8
	collision_mask = 1<<1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.num_de_chaves += 1
		body._obter_chaves()
		call_deferred("queue_free")
		print(body.num_de_chaves)
		print(body.chave)
