extends RigidBody2D

var speed = 1000  # Velocidade da bala

func _ready():
	gravity_scale = 0  # Desativa a gravidade para a bala
	linear_velocity = Vector2(speed, 0).rotated(rotation)  # Define a velocidade na direção da rotação
	add_to_group("Bullet Fire")  # Certifique-se de que o grupo está correto

# Função chamada ao colidir com um objeto
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Cenario") or body.is_in_group("Inimigos"):
		queue_free()  # Remove a bala da cena ao colidir
