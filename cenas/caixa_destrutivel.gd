extends Area2D


var vida_caixa = 15
var drop_spawn = preload("res://cenas/escudo.tscn")
var drop_spawn2 = preload("res://cenas/powerupp_vida.tscn")
var numero_de_powerups = int(randf_range(1, 2))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", Callable(self, "on_body_entered"))
	collision_layer = 1<<10
	collision_mask = 3<<3
	
func _on_body_entered(body: Node2D) -> void:
	print("trap acionada")
	vida_caixa -= 5
	if vida_caixa <= 0:
		if body.is_in_group("Bullet"):
			for i in range(numero_de_powerups):
				var drops = drop_spawn.instantiate()
				var drops2 = drop_spawn2.instantiate()
				drops.position = position + Vector2(randf_range(-25,25), randf_range(-25, 25))
				drops2.position = position + Vector2(randf_range(-25,25), randf_range(-25, 25))
				get_tree().current_scene.add_child(drops2)
				get_tree().current_scene.add_child(drops)
			queue_free()
