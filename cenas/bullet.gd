extends RigidBody2D

func _ready():
	gravity_scale = 0  # Desativa a gravidade para esta bala
	add_to_group("Bullet")
	collision_layer = 1 << 3 # Bala na Layer 4 collision_mask &= ~(1 << 1) # Ignore colisão com jogador (Layer 2)
	collision_mask &= ~(1 << 1)
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Cenario") or body.is_in_group("Inimigos") or body.is_in_group("Boss") or body.is_in_group("mini_boss"):
		queue_free()
