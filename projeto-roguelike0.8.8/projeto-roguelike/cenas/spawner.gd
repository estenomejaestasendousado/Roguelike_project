extends Node2D

@onready var inimigo = preload("res://cenas/inimigo.tscn")
@export var max_inimigos = 10  # Limite máximo de inimigos
var contador_inimigos = 0

func _on_timer_timeout() -> void:
	if contador_inimigos < max_inimigos:
		var inimigo_spawn = inimigo.instantiate()

		# Define o intervalo de spawn para os eixos X e Y
		var spawn_x = randf_range(100, 600)  # Altere os valores conforme necessário
		var spawn_y = randf_range(100, 400)  # Altere os valores conforme necessário
		# Atualiza a posição de spawn aleatória
		inimigo_spawn.position = Vector2(spawn_x, spawn_y)
		get_parent().add_child(inimigo_spawn)
		
		# Incrementa a contagem de inimigos
		contador_inimigos += 1
		
		# Conecta o sinal "died" ao método _on_inimigo_died usando Callable
		inimigo_spawn.connect("died", Callable(self, "_on_inimigo_died"))

func _on_inimigo_died():
	# Decrementa a contagem de inimigos quando um inimigo morre
	contador_inimigos -= 1
