extends RigidBody2D

var speed = 1000  # Velocidade da bala

func _ready():
	gravity_scale = 0  # Desativa a gravidade para esta bala
	linear_velocity = Vector2(speed, 0).rotated(rotation)  # Define a velocidade na direção da rotação
	add_to_group("Bullet")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Cenario") or body.is_in_group("Inimigos"):
		queue_free()
