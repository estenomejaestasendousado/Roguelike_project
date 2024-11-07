extends Node2D

@onready var power_up = preload("res://cenas/powerupp_vida.tscn")
var kill_count = 0
var power_spawn_limit = 5

func _ready() -> void:
	pass

func kill_increment_counter():
	kill_count += 1
	print("Kills: ", kill_count)
	
	if kill_count % power_spawn_limit == 0:
		spawn_powerup()

func spawn_powerup():
	var powerup = power_up.instantiate()
	var spawn_x = randf_range(100, 600)  # Altere conforme necessário
	var spawn_y = randf_range(100, 400)  # Altere conforme necessário
	powerup.position = Vector2(spawn_x, spawn_y)
	add_child(powerup)  # Adiciona o power-up à árvore de cena
