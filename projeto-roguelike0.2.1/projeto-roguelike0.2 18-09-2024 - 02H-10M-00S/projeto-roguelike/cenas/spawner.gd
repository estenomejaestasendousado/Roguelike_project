extends Node2D

@onready var inimigo = preload("res://cenas/inimigo.tscn")

func _on_timer_timeout() -> void:
	var inimigo_spawn = inimigo.instantiate()

	# Define o intervalo de spawn para os eixos X e Y
	var spawn_x = randf_range(100, 600) # Altere os valores conforme necessário
	var spawn_y = randf_range(100, 400) # Altere os valores conforme necessário
	# Atualiza a posição de spawn aleatória
	inimigo_spawn.position = Vector2(spawn_x, spawn_y)
	get_parent().add_child(inimigo_spawn)
