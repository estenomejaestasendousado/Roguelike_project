extends Node2D

@onready var neve = $CPUParticles2D  # Referência ao nó de partículas

func _ready():
	neve.emitting = true  # Começa a emissão das partículas
	neve.amount = 1000   # Número de partículas
	neve.set_position(Vector2(randf_range(0, 800), 0))
