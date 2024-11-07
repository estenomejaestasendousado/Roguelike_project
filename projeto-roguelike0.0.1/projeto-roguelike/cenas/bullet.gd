extends RigidBody2D

var speed = 1000  # Velocidade da bala

func _ready():
	gravity_scale = 0  # Desativa a gravidade para esta bala
	linear_velocity = Vector2(speed, 0).rotated(rotation)  # Define a velocidade na direção da rotação
