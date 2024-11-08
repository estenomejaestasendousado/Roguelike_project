extends Area2D


var inimigo_spawn = preload("res://cenas/inimigo.tscn")
var numero_de_inimigos = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	collision_layer = 1 << 5
	collision_mask = 1 << 1
	
func randf_range(min, max):
	return min + randf() * (max - min)

func _on_body_entered(body: Node2D) -> void:
	print("trap acionada")
	if body.is_in_group("Player"):
		for i in range(numero_de_inimigos):
			var inimigo = inimigo_spawn.instantiate()
			inimigo.position = position + Vector2(randf_range(-25,25), randf_range(-25, 25))
			get_tree().current_scene.add_child(inimigo)
		queue_free()
